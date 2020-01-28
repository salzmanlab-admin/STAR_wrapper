# FDR junc calls
# Created: 6 January 2019
# Purpose: Get list of all junctions "called" across all cells

import argparse
from glob import glob
import numpy as np
import pandas as pd
import time

def get_names(data_paths, col):
  dp_dict = {}
  for data_path in data_paths: 
    dp_dict[data_path] = {"err" : 0, "yes" : 0, "no" : 0, "names": []}
    for d in glob(data_path + "*/"):
      try:
        with open(d + "GLM_output.txt","r") as f:
          line = f.readline()[:-1].split("\t")
          
          # make sure file has the required column
          if col in line:
            dp_dict[data_path]["yes"] += 1
            dp_dict[data_path]["names"].append(d.split("/")[-2])
          else:
            dp_dict[data_path]["no"] += 1
      except Exception as e:
        print("exception", e)
        dp_dict[data_path]["err"] += 1
    print(len(dp_dict[data_path]["names"]),"names")
  return dp_dict

def get_score_df(results, data_path, col, use_cols, score_df, unlim_read, frac_genomic, sd_overlap, avg_AT):
  t0 = time.time()
  for i in range(len(results["names"])):
    if i % 10 == 0:
      
      print(i,time.time() - t0)
    name = results["names"][i]
    temp_df = pd.read_csv("{}{}/GLM_output.txt".format(data_path,name),usecols=use_cols,sep="\t")
#    if not unlim_read:
#      temp_df = temp_df[temp_df["numReads"] > 1]
    temp_df = temp_df[(temp_df["is.STAR_Chim"].isna())]
#    if frac_genomic:
#      temp_df = temp_df["frac_genomic_reads"] == 0)
    if frac_genomic:
      temp_df = temp_df[temp_df["frac_genomic_reads"] < 0.1]
    if sd_overlap:
      temp_df = temp_df[temp_df["sd_overlap"] > 0.25]
    if avg_AT:
      temp_df = temp_df[temp_df["ave_AT_run_R1"] < 11]
    temp_df["intron_length"] = abs(temp_df["refName_newR1"].str.split(":").str[2].astype(int) - temp_df["refName_newR1"].str.split(":").str[5].astype(int))
    temp_df = temp_df[temp_df["intron_length"] > 30]
    score_df = pd.concat([score_df, temp_df[use_cols[:2]]], axis=0)
  return score_df

def get_medians(score_df, col):
  y = score_df.groupby("refName_newR1").agg({col : [lambda x : np.quantile(a=x,q=0.5)]})
  q_dict = y[col][y[col].columns[0]]
  median_df = y[col].rename(columns={y[col].columns[0] : "{}_median".format(col)})
  median_df = median_df.sort_values(by="{}_median".format(col))
  return median_df

def write_files(median_df, col, data_path, dp_dict,unlim_read, value, frac_genomic, sd_overlap, avg_AT):
#  if unlim_read:
#    suffix = "_unlim_read"
#  else:
#    suffix = ""
  suffix = ""
  if frac_genomic:
    suffix += "_fg"
  if sd_overlap:
    suffix += "_so25"
  if avg_AT:
    suffix += "_aa" 
  if suffix == "":
    suffix = "_no_filt"
#  suffix = "_no_filt"
  median_df.to_csv("{}{}_median{}_{}.tsv".format(data_path,col,suffix,value),sep="\t")
  median_df[median_df["{}_median".format(col)] > value][[]].to_csv("{}{}_passed{}_{}.txt".format(data_path,col,suffix,value),header=False)
  median_df[median_df["{}_median".format(col)] <= value][[]].to_csv("{}{}_failed{}_{}.txt".format(data_path,col,suffix,value),header=False)
  name_file = open("{}{}_cell_ids{}.txt".format(data_path,col,suffix),"w")
  for key, results in dp_dict.items():
    for name in results["names"]:
      name_file.write(name + "\n")
  name_file.close()
  print("total # junctions",median_df.shape[0])
  print("passed junctions",median_df[median_df["{}_median".format(col)] > value].shape[0])
  print("failed junctions",median_df[median_df["{}_median".format(col)] <= value].shape[0])

def get_args():
  parser = argparse.ArgumentParser(description="make junction calls based on all cells")
  parser.add_argument("-d", "--data_paths", nargs="+", help="The paths containing all the folders for the different SICILIAN runs")
  parser.add_argument("-m", "--method", help="method of sequencing", choices=["ss2","10x"])
  parser.add_argument("-u","--unlim_read",action="store_true",help="don't include 1 read limit")
  parser.add_argument("-v","--value",help="cutoff value",type=float, default = 0.75)
  parser.add_argument("--frac_genomic",action="store_true",help="filter with frac_genomic == 0")
  parser.add_argument("--sd_overlap",action="store_true",help="filter with sd_overlap > 0.5")
  parser.add_argument("--avg_AT",action="store_true",help="filter with ave AT run < 11")
  args = parser.parse_args()
  return args

def main():

  args = get_args()

  if args.method == "ss2":
    col = "junc_cdf_glmnet_corrected_constrained"
  elif args.method == "10x":
    col = "junc_cdf_glmnet_constrained"

  dp_dict = get_names(args.data_paths, col)

  use_cols = ["refName_newR1", col,"is.STAR_Chim","numReads","frac_genomic_reads","sd_overlap","ave_AT_run_R1"]
  score_df = pd.DataFrame(columns = use_cols[:2])
  
  for data_path in args.data_paths:
    score_df = get_score_df(dp_dict[data_path], data_path, col, use_cols, score_df, args.unlim_read, args.frac_genomic, args.sd_overlap, args.avg_AT)

  median_df = get_medians(score_df, col)
  for data_path in args.data_paths:
    write_files(median_df, col, data_path, dp_dict, args.unlim_read, args.value, args.frac_genomic, args.sd_overlap, args.avg_AT)
main()
