from glob import glob
import os
import subprocess
import sys
import time
import argparse

def sbatch_file(file_name, job_name, time, mem, command, dep="", dep_type = "afterok"):
  """Write sbatch script given parameters"""
  job_file = open(file_name, "w")
  job_file.write("#!/bin/bash\n#\n")
  job_file.write("#SBATCH --job-name=" + job_name + "\n")
  job_file.write("#SBATCH --output=../job_output/{}.%j.out\n".format(job_name))
  job_file.write("#SBATCH --error=../job_output/{}.%j.err\n".format(job_name))
  job_file.write("#SBATCH --time={}\n".format(time))
 # job_file.write("#SBATCH --qos=normal\n")
#  job_file.write("#SBATCH -p horence\n")
  job_file.write("#SBATCH -p owners\n")
  job_file.write("#SBATCH --nodes=1\n")
  job_file.write("#SBATCH --mem={}\n".format(mem))
  if dep != "":
    job_file.write("#SBATCH --dependency={}:{}\n".format(dep_type,dep))
    job_file.write("#SBATCH --kill-on-invalid-dep=yes\n")
  job_file.write("date\n")
  job_file.write(command + "\n")
  job_file.write("date\n")
  job_file.close()


def submit_job(file_name):
  """Submit sbatch job to cluster"""
  status, job_num = subprocess.getstatusoutput("sbatch {}".format(file_name))
  if status == 0:
    print("{} ({})".format(job_num, file_name))
    return job_num.split()[-1]
  else:
    print("Error submitting job {} {} {}".format(status, job_num, file_name))



def circle(data_path, name, p_thresh, single, end):
  command = "python3 circ_summary.py --input_file {} --out_class_file {} --out_summary_file {} --p_thresh {}".format("{}{}/class_input_WithinBAM{}".format(data_path, name, end), "{}{}/class_input_WithinBAM{}".format(data_path, name, end), "{}{}/circ_summary.tsv".format(data_path, name), p_thresh)
  if single:
    command += " --single"
  sbatch_file("../run_circ.sh", "circ_{}".format(name), "5:00:00", "60Gb", command)
  return submit_job("../run_circ.sh")

def main():
  results = {"yes" : 0, "no" : 0, "err" : 0, "names" : []}
#  files = "smartseq"
  files = "10x"

  if files == "smartseq":
    data_path ="/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/" 
    end = ".tsv"
    p_col = "glmnet_per_read_prob_corrected"
    single = False

  elif files == "10x":
    data_path = "/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"
    end = ".txt"
    p_col = "p_predicted_glmnet"
    single = True

  for d in glob(data_path + "*/"):
    try:
      with open(d + "class_input_WithinBAM" + end,"r") as f:
        line = f.readline()[:-1].split("\t")
        if p_col in line:
          results["yes"] += 1
          results["names"].append(d.split("/")[-2])
        else:
          results["no"] += 1
    except Exception as e:
      print("exception", e)
      results["err"] += 1
  print("num names", len(results["names"]))
  print('results', results)

  done_names = []
  errs = 0
  for d in glob(data_path + "*/"):
    try:
      with open(d + "circ_summary.tsv","r") as f:
        line = f.readline()[:-1].split("\t")
      done_names.append(d.split("/")[-2])  
    except:
      errs += 1
#  data_path = "/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"
  print("num done", len(done_names))
  p_thresh = 0.99
#  results["names"] = ["B107809_B9_S152", "B107809_I4_S8", "B107809_J2_S29", "B107809_J5_S32", "B107809_M14_S110", "B107809_N10_S129", "B107809_N20_S139", "B107810_C1_S179", "B107810_D2_S203", "B107810_I3_S19", 
#"B107810_M4_S112"]  
  names = [x for x in results["names"] if x not in done_names]
  for name in names:
    print(name)
    circle(data_path, name, p_thresh, single, end)
main()
