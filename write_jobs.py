# Wrapper script for STAR and statistical modeling
# Created by Julia Olivieri
# 17 June 2019

import glob
import os
import subprocess
import sys
import time

def sbatch_file(file_name, job_name, time, mem, command, dep="", dep_type = "afterok"):
  """Write sbatch script given parameters"""
  job_file = open(file_name, "w")
  job_file.write("#!/bin/bash\n#\n")
  job_file.write("#SBATCH --job-name=" + job_name + "\n")
  job_file.write("#SBATCH --output=job_output/{}.%j.out\n".format(job_name))
  job_file.write("#SBATCH --error=job_output/{}.%j.err\n".format(job_name))
  job_file.write("#SBATCH --time={}\n".format(time))
 # job_file.write("#SBATCH --qos=normal\n")
#  job_file.write("#SBATCH -p horence\n")
  job_file.write("#SBATCH -p horence\n")
  job_file.write("#SBATCH --nodes=1\n")
  job_file.write("#SBATCH --mem={}\n".format(mem)) 
  if dep != "":
    job_file.write("#SBATCH --dependency={}:{}\n".format(dep_type,dep))
    job_file.write("#SBATCH --kill-on-invalid-dep=yes\n")
  job_file.write("date\n")
  job_file.write(command + "\n")
  job_file.write("date\n")
  job_file.close()

def ensembl(out_path, name, assembly, single, dep = ""):
  """Run script to add both ensembl gene ids and gene counts to the class input files"""
  command = "Rscript scripts/add_ensembl_id.R {}{}/  {}".format(out_path, name, assembly)
  if single:
    command += " 1 "
  sbatch_file("run_ensembl.sh", "ensembl_{}".format(name), "12:00:00", "10Gb", command, dep=dep)
  return submit_job("run_ensembl.sh")


def ann_SJ(out_path, name, assembly, gtf_file, single, dep = ""):
  """Run script to add gene names to SJ.out.tab and Chimeric.out.junction"""
  command = "python3 scripts/annotate_SJ.py -i {}{}/ -a {} -g {} ".format(out_path, name, assembly, gtf_file)
  if single:
    command += "--single "
  sbatch_file("run_ann_SJ.sh", "ann_SJ_{}".format(name), "24:00:00", "50Gb", command, dep=dep)
  return submit_job("run_ann_SJ.sh")

def class_input(out_path, name, assembly, gtf_file, single,dep=""):
  """Run script to create class input file"""
  command = "python3 scripts/create_class_input.py -i {}{}/ -a {} -g {} ".format(out_path, name, assembly, gtf_file)
  if single:
    command += "--single"
  sbatch_file("run_class_input.sh", "class_input_{}".format(name), "24:00:00", "50Gb", command, dep=dep)
  return submit_job("run_class_input.sh")


def STAR_map(out_path, data_path, name, r_ends, assembly, gzip, cSM, cJOM, aSJMN, cSRGM, single, gtf_file):
  """Run script to perform mapping job for STAR"""
  command = "mkdir -p {}{}\n".format(out_path, name)
  command += "STAR --version\n"
  if single:
    l = 1
  else:
    l = 0
  for i in range(l,2):
    command += "/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 "
    command += "--alignIntronMax 21 "
    command += "--genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/{}_index_2.7.1a ".format(assembly)
    command += "--readFilesIn {}{}{} ".format(data_path, name, r_ends[i])
    if gzip:
      command += "--readFilesCommand zcat "
    command += "--twopassMode Basic "
    command += "--outFileNamePrefix {}{}/{} ".format(out_path, name, i + 1)
    command += "--outSAMtype SAM "
    command += "--chimSegmentMin {} ".format(cSM)
    command += "--outSAMattributes All "
    command += "--chimOutType Junctions SeparateSAMold "
    command += "--chimJunctionOverhangMin {} ".format(cJOM)
    command += "--alignSJstitchMismatchNmax {} -1 {} {} ".format(aSJMN, aSJMN, aSJMN)
    command += "--chimSegmentReadGapMax {} ".format(cSRGM)
    command += "--quantMode GeneCounts "
    command += "--sjdbGTFfile {} ".format(gtf_file)
    command += "--outReadsUnmapped Fastx \n\n"
  sbatch_file("run_map.sh", "map_{}".format(name), "12:00:00", "50Gb", command)
  return submit_job("run_map.sh")

def log(out_path, name, jobs, dep = ""):
  """Run job to concatenate all individual job outputs for the sample into one file"""
  command = "python3 scripts/create_log.py -i {}{}/ -j {}".format(out_path,name, " ".join(jobs))
  sbatch_file("run_log.sh", "log_{}".format(name), "5:00", "500", command, dep = dep,dep_type = "afterany")
  return submit_job("run_log.sh")

def submit_job(file_name):
  """Submit sbatch job to cluster"""
  status, job_num = subprocess.getstatusoutput("sbatch {}".format(file_name))
  if status == 0:
    print("{} ({})".format(job_num, file_name))
    return job_num.split()[-1]
  else:
    print("Error submitting job {} {} {}".format(status, job_num, file_name))

def main():

#  chimSegmentMin = [12,10] 
#  chimJunctionOverhangMin = [13, 10]
#  alignSJstitchMismatchNmax = [0,1]
#  chimSegmentReadGapMax = [0,3]

  chimSegmentMin = [10] 
  chimJunctionOverhangMin = [10]
  alignSJstitchMismatchNmax = [0]
  chimSegmentReadGapMax = [0]

  # Krasnow Biohub
#  data_path = "/scratch/PI/horence/Roozbeh/single_cell_project/data/biohub/rawdata/"
#  assembly = "hg38"
#  run_name = "Krasnow_biohub"
#  r_ends = ["_R1_001.fastq.gz","_R2_001.fastq.gz"]
#  names = ["P9-B002581-B002581-1_S324", "P9-B001222-B001222-1_S155", "P8-B002581-B002581-1_S323", "P8-B001222-B001222-1_S154", "P7-B001222-B001222-1_S153", "P6-B001222-B001222-1_S152", "P5-B002581-B002581-1_S322"]
#  gtf_file = "/share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf"
#  names = ["P9-B002581-B002581-1_S324"]

  # benchmarking
#  data_path = "/scratch/PI/horence/Roozbeh/single_cell_project/data/benchmarking/"
#  assembly = "hg38"
#  run_name = "benchmarking"
#  r_ends = ["_1.fastq", "_2.fastq"]
##  names = ["SRR6782109", "SRR6782110", "SRR6782111", "SRR6782112", "SRR7547688", "SRR7547689", "SRR7547690", "SRR7547691", "SRR7547692", "SRR7588583", "SRR7588671", "SRR7706271", "SRR7706277"]
#  gtf_file = "/share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf"
#  names = ["SRR7547691"]
#  single = True

  # Tabula Muris lung
#  data_path = "/scratch/PI/horence/JuliaO/single_cell/data/SRA/19.06.19.GSE109774/"
#  assembly = "mm10"
#  run_name = "GSE109774_lung"
#  r_ends = ["_1.fastq.gz", "_2.fastq.gz"]
#  names = ["SRR65770{}".format(i) for i in range(46, 58)]
#  gtf_file = "/scratch/PI/horence/JuliaO/single_cell/STAR_output/{}_files/{}.gtf".format(assembly, assembly)

 # Tabula Muris colon
#  data_path = "/scratch/PI/horence/JuliaO/single_cell/data/SRA/19.05.31.GSE109774/"
#  assembly = "mm10"
#  run_name = "GSE109774_colon"
#  r_ends = ["_1.fastq.gz", "_2.fastq.gz"]
##  names = ["SRR65462{}".format(i) for i in range(73,85)]
#  names = ["SRR65462{}".format(i) for i in range(75,76)]
#  single = False
#  gtf_file = "/scratch/PI/horence/JuliaO/single_cell/STAR_output/{}_files/{}.gtf".format(assembly, assembly)

# Tabula Sapiens pilot
  data_path = "/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/"
  assembly = "hg38"
  run_name = "TS_pilot"
  r_ends = ["possorted_genome_bam.fq", "possorted_genome_bam.fq"]
  names = ["TSP1_bladder_1", "TSP1_lung_1"]
  gtf_file = "/share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf"
  single = True


# Tabula Sapiens demultiplexed pilot
  data_path = "/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_bladder_1/"
  assembly = "hg38"
  run_name = "TS_pilot_demultiplexed"
  r_ends = ["_001.fastq.gz", "001.fastq.gz"]
  names = ["TSP1_bladder_1_S13_L001_R2"]
  gtf_file = "/share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf"
  single = True


  # path that contains fastqs
#  data_path = ""

  # assembly and gtf file to use for alignment
#  assembly = "mm10"

  # unique endings for the file names of read one (location 0) and read 2 (location 1)
#  r_ends = ["_1.fastq.gz", "_2.fastq.gz"]

  # unique identifiers for each fastq; file location for read 1 should be <data_path><name><r_ends[0]>
#  names = ["SRR65462{}".format(i) for i in range(73,85)]

  run_map = False
  run_ann = False
  run_class = False
  run_ensembl = True 
 
  if r_ends[0].split(".")[-1] == "gz":
    gzip = True
  else:
    gzip = False

  for cSM in chimSegmentMin:
    for cJOM in chimJunctionOverhangMin:
      for aSJMN in alignSJstitchMismatchNmax:
        for cSRGM in chimSegmentReadGapMax:
          cond_run_name = run_name + "_cSM_{}_cJOM_{}_aSJMN_{}_cSRGM_{}".format(cSM, cJOM, aSJMN, cSRGM)
          out_path = "/scratch/PI/horence/Roozbeh/single_cell_project/output/{}/".format(cond_run_name)
        #  gtf_file = "/scratch/PI/horence/JuliaO/single_cell/STAR_output/{}_files/{}.gtf".format(assembly, assembly)
#          gtf_file = "/share/PI/horence/circularRNApipeline_Cluster/index/{}_genes.gtf".format(assembly)
        
        
          total_jobs = []
          total_job_names = []
          for name in names:
            jobs = []
            if run_map:
              map_jobid = STAR_map(out_path, data_path, name, r_ends, assembly, gzip, cSM, cJOM, aSJMN, cSRGM, single, gtf_file)
              jobs.append("map_{}.{}".format(name,map_jobid))
              total_jobs.append(map_jobid)
            else:
              map_jobid = ""
        
            if run_ann:
              ann_SJ_jobid = ann_SJ(out_path, name, assembly, gtf_file, single, dep = map_jobid)
              jobs.append("ann_SJ_{}.{}".format(name,ann_SJ_jobid))
              total_jobs.append(ann_SJ_jobid)
            else:
              ann_SJ_jobid = ""
        
            if run_class:
              class_input_jobid = class_input(out_path, name, assembly, gtf_file, single, dep=ann_SJ_jobid)
              jobs.append("class_input_{}.{}".format(name,class_input_jobid))
              total_jobs.append(class_input_jobid)
            else:
              class_input_jobid = ""
                             
            if run_ensembl:
             ensembl_jobid = ensembl(out_path, name, assembly, single, dep=class_input_jobid)
             jobs.append("ensembl_{}.{}".format(name,ensembl_jobid))
             total_jobs.append(ensembl_jobid)
            else:
              ensembl_jobid = ""
        
            log_jobid = log(out_path, name, jobs, dep = ensembl_jobid)
            jobs.append("log_{}.{}".format(name,log_jobid))
            total_jobs.append(log_jobid)
        
            total_job_names += jobs 
          log(out_path, "", sorted(total_job_names), dep = ":".join(total_jobs))

main()
