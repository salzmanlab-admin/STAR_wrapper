# FDR junc calls
# Created: 6 January 2019
# Purpose: Get list of all junctions "called" across all cells

import argparse
from glob import glob
import numpy as np
import pandas as pd
import pickle
import time

def get_names(data_paths, col, use_cols):
  dp_dict = {}
  for data_path in data_paths: 
    dp_dict[data_path] = {"err" : 0, "yes" : 0, "no" : 0, "names": []}
    for d in glob(data_path + "*/"):
      try:
        with open(d + "GLM_output.txt","r") as f:
          unsplit_line = f.readline()[:-1]
          line = unsplit_line.split("\t")
          
          # make sure file has the required column
#          if col in line and "ave_entropyR1" in line:
          if len([ele for ele in use_cols if ele in line]) == len(use_cols):
#            print("in line",[ele for ele in use_cols if ele in line])
#            print(d)
            dp_dict[data_path]["yes"] += 1
            dp_dict[data_path]["names"].append(d.split("/")[-2])
#          else:
#            dp_dict[data_path]["no"] += 1
      except Exception as e:
        print("exception", e)
        dp_dict[data_path]["err"] += 1
    print(len(dp_dict[data_path]["names"]),"names")
  return dp_dict

def get_score_df(results, data_path, col, use_cols, score_df, hard_filt_df, unlim_read, frac_genomic, sd_overlap, avg_AT, avg_ent, intron_len, avg_GC, prefix=""):
  t0 = time.time()
  for i in range(len(results["names"])):
    if i % 10 == 0:
      
      print(i,time.time() - t0)
    name = results["names"][i]
    if name.startswith(prefix):

#      print("before read",data_path,name)
      temp_df = pd.read_csv("{}{}/GLM_output.txt".format(data_path,name),usecols=use_cols,sep="\t")
      temp_hard_df = temp_df
      temp_hard_df["hard_inc"] = 0
      temp_hard_df = temp_hard_df[["refName_newR1","hard_inc"]]
  #    if not unlim_read:
  #      temp_df = temp_df[temp_df["numReads"] > 1]
      temp_df = temp_df[(temp_df["is.STAR_Chim"].isna())]
  #    if frac_genomic:
  #      temp_df = temp_df["frac_genomic_reads"] == 0)
      if frac_genomic:
        temp_df = temp_df[temp_df["frac_genomic_reads"] < 0.1]
      if sd_overlap:
        temp_df = temp_df[temp_df["sd_overlap"] > 0]
      if avg_AT:
        temp_df = temp_df[temp_df["ave_AT_run_R1"] < 11]
      if avg_GC:
        temp_df = temp_df[temp_df["ave_GC_run_R1"] < 11]
      if avg_ent:
        temp_df = temp_df[temp_df["ave_entropyR1"] > 3]
  
      if intron_len:
        temp_df["intron_length"] = abs(temp_df["refName_newR1"].str.split(":").str[2].astype(int) - temp_df["refName_newR1"].str.split(":").str[5].astype(int))
        temp_df = temp_df[temp_df["intron_length"] > 30]
      temp_hard_df.loc[temp_df.index,"hard_inc"] = 1
      score_df = pd.concat([score_df, temp_df[use_cols[:2]]], axis=0)
      hard_filt_df = pd.concat([hard_filt_df, temp_hard_df],axis=0)
  return score_df, hard_filt_df

def get_medians(score_df, col):
#  pickle.dump(score_df, open("/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/test/score_df{}.pkl".format(col),"wb"))
  vc = score_df["refName_newR1"].value_counts()
  score_df["num_samples"] = score_df["refName_newR1"].map(vc)
  median_df1 = score_df[score_df["num_samples"] == 1][["refName_newR1",col]].rename(columns={col : col + "_median"})
  median_df1 = median_df1.set_index("refName_newR1")
  score_df = score_df[score_df["num_samples"] > 1][["refName_newR1",col]]
  print("at func")
  y = score_df.groupby("refName_newR1").agg({col : [lambda x : np.quantile(a=x,q=0.5)]})
  print("y")
  q_dict = y[col][y[col].columns[0]]
  print("q_dict")
  median_df = y[col].rename(columns={y[col].columns[0] : "{}_median".format(col)})
  print("median df")
  median_df = median_df.append(median_df1)
  print("df concat")
  median_df = median_df.sort_values(by="{}_median".format(col))
  print("sorted")
  return median_df

def write_files(median_df, col, data_path, dp_dict,unlim_read, value, frac_genomic, sd_overlap, avg_AT, avg_ent, intron_len, avg_GC, prefix = ""):
#  if unlim_read:
#    suffix = "_unlim_read"
#  else:
#    suffix = ""
  suffix = ""
  if frac_genomic:
    suffix += "_fg"
  if sd_overlap:
    suffix += "_so"
  if avg_AT:
    suffix += "_aa" 
  if avg_GC:
    suffix += "_ag" 

  if avg_ent:
    suffix += "_ae"
  if intron_len:
    suffix += "_il"
  if suffix == "":
    suffix = "_no_filt"
#  suffix = "_no_filt"
  median_df.to_csv("{}{}_median{}_{}.tsv".format(data_path,col,suffix,value),sep="\t")
  if col.startswith("junc_cdf"):
    median_df[median_df["{}_median".format(col)] > value][[]].to_csv("{}{}{}_passed{}_{}.txt".format(data_path,prefix,col,suffix,value),header=False)
    median_df[median_df["{}_median".format(col)] <= value][[]].to_csv("{}{}{}_failed{}_{}.txt".format(data_path,prefix,col,suffix,value),header=False)
  elif col.startswith("emp.p"):
    median_df[median_df["{}_median".format(col)] < value][[]].to_csv("{}{}{}_passed{}_{}.txt".format(data_path,prefix,col,suffix,value),header=False)
    median_df[median_df["{}_median".format(col)] >= value][[]].to_csv("{}{}{}_failed{}_{}.txt".format(data_path,prefix,col,suffix,value),header=False)
  elif col == "hard_inc":
    median_df[median_df["{}_median".format(col)] >= value][[]].to_csv("{}{}{}_passed{}_{}.txt".format(data_path,prefix,col,suffix,value),header=False)
    median_df[median_df["{}_median".format(col)] < value][[]].to_csv("{}{}{}_failed{}_{}.txt".format(data_path,prefix,col,suffix,value),header=False)

  name_file = open("{}{}{}_cell_ids{}.txt".format(data_path,prefix,col,suffix),"w")
  for key, results in dp_dict.items():
    for name in results["names"]:
      if name.startswith(prefix):
        name_file.write(name + "\n")
  name_file.close()
  print("total # junctions",median_df.shape[0])
  print("passed junctions",median_df[median_df["{}_median".format(col)] > value].shape[0])
  print("failed junctions",median_df[median_df["{}_median".format(col)] <= value].shape[0])
  return suffix

def get_args():
  parser = argparse.ArgumentParser(description="make junction calls based on all cells")
  parser.add_argument("-d", "--data_paths", nargs="+", help="The paths containing all the folders for the different SICILIAN runs")
  parser.add_argument("-m", "--method", help="method of sequencing", choices=["ss2","10x"])
  parser.add_argument("-u","--unlim_read",action="store_true",help="don't include 1 read limit")
  parser.add_argument("-v","--value",help="cutoff value",type=float, default = 0.15)
  parser.add_argument("--frac_genomic",action="store_true",help="filter with frac_genomic < 0.1")
  parser.add_argument("--sd_overlap",action="store_true",help="filter with sd_overlap > 0")
  parser.add_argument("--avg_AT",action="store_true",help="filter with ave AT run < 11")
  parser.add_argument("--avg_GC",action="store_true",help="filter with ave GC run < 11")
  parser.add_argument("--avg_ent",action="store_true",help="filter with ave entropy > 3")
  parser.add_argument("--intron_len",action="store_true",help="filter intron len > 30")
  parser.add_argument("--prefix",help="Only process folders with this prefix",default="")

  parser.add_argument("--col",help="column to use",default="emp.p")
  parser.add_argument("--outpath",help="where to write output",default="")

  args = parser.parse_args()
  return args

def main():

  args = get_args()

  if args.method == "ss2":
    col = args.col + "_glmnet_corrected_constrained"
  elif args.method == "10x":
    col = args.col + "_glmnet_constrained"
  use_cols = ["refName_newR1", col,"is.STAR_Chim","numReads","frac_genomic_reads","sd_overlap","ave_AT_run_R1"]
#  prefix = "MLCA_ANTOINE_LUNG_"

  if args.avg_ent:
    use_cols.append("ave_entropyR1")
  if args.avg_GC:
    use_cols.append("ave_GC_run_R1")
  dp_dict = get_names(args.data_paths, col, use_cols)

  score_df = pd.DataFrame(columns = use_cols[:2])
  hard_filt_df = pd.DataFrame(columns = ["refName_newR1","hard_inc"])
  for data_path in args.data_paths:
#    print("data_path", data_path)
#    if "/" + prefix in data_path:
#      print("parsed",data_path)
    score_df, hard_filt_df = get_score_df(dp_dict[data_path], data_path, col, use_cols, score_df, hard_filt_df, args.unlim_read, args.frac_genomic, args.sd_overlap, args.avg_AT, args.avg_ent, args.intron_len, args.avg_GC,args.prefix)
  median_df = get_medians(score_df, col)

  print("got median 1")
#  print(hard_filt_df.head())
#  pickle.dump(hard_filt_df,open("/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/test/hard_filt_df.pkl","wb"))
  hard_median_df = get_medians(hard_filt_df,"hard_inc")
#median_df.to_csv("{}{}_median{}_{}.tsv".format(data_path,col,suffix,value),sep="\t")
  print("got median 2")

  data_paths = args.data_paths
  if args.outpath != "":
    data_paths = [args.outpath]

  for data_path in data_paths:
  
    write_files(median_df, col, data_path, dp_dict, args.unlim_read, args.value, args.frac_genomic, args.sd_overlap, args.avg_AT, args.avg_ent, args.intron_len, args.avg_GC, args.prefix)
    print("wrote files 1")
    suffix = write_files(hard_median_df, "hard_inc", data_path, dp_dict, args.unlim_read, 1, args.frac_genomic, args.sd_overlap, args.avg_AT, args.avg_ent, args.intron_len, args.avg_GC, args.prefix)
    hard_filt_df[hard_filt_df["hard_inc"] > 0].drop_duplicates("refName_newR1")["refName_newR1"].to_csv("{}hard_inc_nonzero{}.tsv".format(data_path,suffix),sep="\t",index=False,header=None)

    print("wrote files 2")
main()
