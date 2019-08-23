# Circle Summary
# Summarize circular junctions found by glm
# Created by Julia Olivieri
# 18 August 2019

import argparse
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import time

def main():
  t0 = time.time()
  parser = argparse.ArgumentParser(description="create summary of circles found")
  parser.add_argument("-i", "--input_file", help="the original class input file")
  parser.add_argument("-oc", "--out_class_file", help="the class input file to write to")
  parser.add_argument("-os", "--out_summary_file", help="the summary file to write to")
  parser.add_argument("-s", "--single", action="store_true", help="use this flag if the reads you are running on are single-ended")
  parser.add_argument("-p", "--p_thresh", type = float, default=0.99, help="the treshold to use for the p values")
  args = parser.parse_args()

#  outpath = "/scratch/PI/horence/JuliaO/single_cell/scripts/output/Circle_Summary/"
#
#  # load data
#  outname = "B107810_K1_S63"
#  df = pd.read_csv("/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/{}/class_input_WithinBAM.tsv".format(outname),
#                  sep="\t")
#  single = False

#  outname = "TSP1_endopancreas_1_S7_L004"
#  df = pd.read_csv("/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/{}/class_input_WithinBAM.tsv".format(outname),
#                  sep="\t")
#  single = True
  df = pd.read_csv(args.input_file, sep="\t")


  # set parameters
#  p_col = "p_predicted_glmnet_corrected"
#  p_thresh = 0.99

  # find circles

  if args.single:
    p_col = "p_predicted_glmnet"
    circ_df = df[(df["readClassR1"] == "rev") & (df[p_col] > args.p_thresh)]


  else:
    p_col = "p_predicted_glmnet_corrected"
    circ_df = df[(df["readClassR1"] == "rev") & (df["location_compatible"] == 1) & 
             (df["read_strand_compatible"] == 1) & (df[p_col] > args.p_thresh)]


  if circ_df.shape[0] > 0:
    vc = circ_df["refName_ABR1"].value_counts()
    circ_df["refName_ABR1_count"] = circ_df.apply(lambda row: vc[row["refName_ABR1"]], axis=1)
    out_df = circ_df.drop_duplicates(subset=["refName_ABR1"], keep="first")
  
    
    halves = ["donor", "acceptor"]
    half_dict = {"donor" : "A", "acceptor" : "B"}
    classes = ["total","fus", "lin", "rev"]
    vals = ["count", "unique"]
    new_cols = []
    for h in halves:
      for c in classes:
        for v in vals:
          out_df["{}_{}_{}".format(h, c, v)] = 0
          new_cols.append("{}_{}_{}".format(h, c, v))
    out_df.head()
    for i, row in out_df.iterrows():
    #   print(row["refName_ABR1"])
      for h in halves:
        half = half_dict[h]
        sub_df = df[(df["chrR1" + half] == row["chrR1" + half]) & 
               (df["geneR1" + half] == row["geneR1" + half]) & 
               (df["juncPosR1" + half] == row["juncPosR1" + half]) &
               (df[p_col] > args.p_thresh)]
        for c in classes:
          if c == "total":
            sub_sub_df = sub_df
          else:
            sub_sub_df = sub_df[sub_df["readClassR1"] == c]
          out_df.at[i,"{}_{}_{}".format(h, c, "count")] = sub_sub_df.shape[0]
          out_df.at[i,"{}_{}_{}".format(h, c, "unique")] = sub_sub_df["refName_ABR1"].nunique()
  
    # want
    cols = ["refName_ABR1",
    "readClassR1",
    p_col,"refName_ABR1_count","seqR1"]
    out_df = out_df[cols + new_cols]
  
    out_df = out_df.sort_values(by=["refName_ABR1_count","donor_total_count","acceptor_total_count"], ascending = False)
    join_df = df.set_index("refName_ABR1").join(out_df[new_cols + ["refName_ABR1_count", "refName_ABR1"]].set_index("refName_ABR1")).reset_index(level="refName_ABR1")
    out_df.to_csv(args.out_summary_file, index = False, sep = "\t")
    join_df.to_csv(args.out_class_file, index = False, sep = "\t")
    print(time.time() - t0)
 
main()
