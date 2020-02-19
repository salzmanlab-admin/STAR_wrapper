import glob
import os
import subprocess
import sys
import time
import argparse

def submit_job(file_name):
  """Submit sbatch job to cluster"""
  status, job_num = subprocess.getstatusoutput("sbatch {}".format(file_name))
  if status == 0:
    print("{} ({})".format(job_num, file_name))
    return job_num.split()[-1]
  else:
    print("Error submitting job {} {} {}".format(status, job_num, file_name))


def sbatch_file(file_name, job_name, time, mem, command, dep="", dep_type = "afterok"):
  """Write sbatch script given parameters"""
  job_file = open(file_name, "w")
  job_file.write("#!/bin/bash\n#\n")
  job_file.write("#SBATCH --job-name=" + job_name + "\n")
  job_file.write("#SBATCH --output=job_output/{}.%j.out\n".format(job_name))
  job_file.write("#SBATCH --error=job_output/{}.%j.err\n".format(job_name))
  job_file.write("#SBATCH --time={}\n".format(time))
  #job_file.write("#SBATCH --qos=high_p\n")
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


def counts(gtf_file, folder_path):
  command = "rm {}*tmp*\n".format(folder_path)
  command += "rm {}gene_assigned\n".format(folder_path)
  command += "rm {}counts.tsv.gz\n".format(folder_path)
  command += "featureCounts -a {} -o {}gene_assigned -R BAM {}2Aligned.out.sorted.bam -T 4\n".format(gtf_file, folder_path, folder_path)
  command += "samtools sort {}2Aligned.out.sorted.bam.featureCounts.bam -o {}assigned_sorted.bam\n".format(folder_path,folder_path)
  command += "samtools index {}assigned_sorted.bam\n".format(folder_path)
  command += "umi_tools count --per-gene --gene-tag=XT --assigned-status-tag=XS --per-cell -I {}assigned_sorted.bam -S {}counts.tsv.gz\n".format(folder_path, folder_path)
  sbatch_file("run_fc.sh", "featureCounts", "4:00:00", "60Gb", command)
  submit_job("run_fc.sh")

def main():
  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/hg38_genes.gtf"
#  gtf_file = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/Lemur_genome/Kransow_reference/ref_Mmur_3.0.gtf"

#  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_171205_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"
#  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_180607_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"
  data_root = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/"
#  data_paths = [data_root + "Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/", 
#                data_root + "Lemur_Bernard_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/",
#                data_root + "Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/",
#                data_root + "Lemur_Stumpy_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"]
  data_paths = [data_root + "TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"]
  for data_path in data_paths:
    for name in glob.glob(data_path + "*/"): 
      print(name)
      if os.path.isfile(name + "counts.tsv.gz"):
        if os.stat(name + "counts.tsv.gz").st_size < 100:
        
          print(name)
          counts(gtf_file, name)

      else:

        print(name)

        counts(gtf_file, name)

main()
