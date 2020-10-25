# Wrapper script for STAR and statistical modeling
# Created by Julia Olivieri
# 17 June 2019

import glob
import os
import subprocess
import sys
import time
import argparse

def sbatch_file(file_name,out_path, name, job_name, time, mem, command, dep="", dep_type = "afterok"):
  """Write sbatch script given parameters"""
  job_file = open(file_name, "w")
  job_file.write("#!/bin/bash\n#\n")
  job_file.write("#SBATCH --job-name=" + job_name + "\n")
  job_file.write("#SBATCH --output={}{}/log_files/{}.%j.out\n".format(out_path, name,job_name))
  job_file.write("#SBATCH --error={}{}/log_files/{}.%j.err\n".format(out_path, name,job_name))
  job_file.write("#SBATCH --time={}\n".format(time))
  #job_file.write("#SBATCH --qos=high_p\n")
#  job_file.write("#SBATCH -p horence\n")
  job_file.write("#SBATCH -p quake,owners\n")
  job_file.write("#SBATCH --nodes=1\n")
  job_file.write("#SBATCH --mem={}\n".format(mem)) 
  if dep != "":
    job_file.write("#SBATCH --dependency={}:{}\n".format(dep_type,dep))
    job_file.write("#SBATCH --kill-on-invalid-dep=yes\n")
  job_file.write("date\n")
  job_file.write(command + "\n")
  job_file.write("date\n")
  job_file.close()


def star_fusion(out_path, name, single, dep = ""):
  """Run star-fusion on chimeric alignments by STAR"""
  command = "/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J "
  if single:
    command += "   {}{}/2Chimeric.out.junction --output_dir {}{}/star_fusion ".format(out_path, name,out_path,name)
  else:
    command += " {}{}/1Chimeric.out.junction --output_dir {}{}/star_fusion ".format(out_path, name,out_path,name)
  sbatch_file("run_star_fusion.sh",out_path, name, "fusion_{}".format(name), "12:00:00", "20Gb", command, dep=dep)
  return submit_job("run_star_fusion.sh")


def GLM(out_path, name, single, assembly, dep = ""):
  """Run the GLM script to compute the statistical scores for junctions in the class input file"""
  command = "Rscript scripts/GLM_script_light.R {}{}/ {} ".format(out_path, name, assembly)
  if single:
    command += " 1 "
  else:
    command += " 0 "
  sbatch_file("run_GLM.sh", out_path, name,"GLM_{}".format(name), "48:00:00", "250Gb", command, dep=dep)  # used 200Gb for CML 80Gb for others and 300 for 10x blood3 
  return submit_job("run_GLM.sh")

def whitelist(data_path,out_path, name, bc_pattern, r_ends):
  command = "mkdir -p {}{}\n".format(out_path, name)
  command += "umi_tools whitelist "
  command += "--stdin {}{}{} ".format(data_path, name, r_ends[0])
  command += "--bc-pattern={} ".format(bc_pattern)
  command += "--log2stderr > {}{}_whitelist.txt ".format(data_path,name)
  command += "--plot-prefix={}{} ".format(data_path, name)
 # command += "--knee-method=density "
  sbatch_file("run_whitelist.sh",out_path, name, "whitelist_{}".format(name), "2:00:00", "20Gb", command)
  return submit_job("run_whitelist.sh")

def extract(out_path, data_path, name, bc_pattern, r_ends, dep = ""):
  command = "umi_tools extract "
  command += "--bc-pattern={} ".format(bc_pattern)
  command += "--stdin {}{}{} ".format(data_path, name, r_ends[0])
  command += "--stdout {}{}_extracted{} ".format(data_path, name, r_ends[0])
  command += "--read2-in {}{}{} ".format(data_path, name, r_ends[1])
  command += "--read2-out={}{}_extracted{} ".format(data_path, name, r_ends[1])
#  command += "--read2-stdout "
  command += "--filter-cell-barcode "
  command += "--whitelist={}{}_whitelist.txt ".format(data_path, name)
  command += "--error-correct-cell "
  sbatch_file("run_extract.sh", out_path, name,"extract_{}".format(name), "20:00:00", "20Gb", command, dep = dep)
  return submit_job("run_extract.sh")


def ann_SJ(out_path, name, assembly, gtf_file, single, dep = ""):
  """Run script to add gene names to SJ.out.tab and Chimeric.out.junction"""
  command = "python3 scripts/annotate_SJ.py -i {}{}/ -a {} -g {} ".format(out_path, name, assembly, gtf_file)
  if single:
    command += "--single "
  sbatch_file("run_ann_SJ.sh", out_path, name,"ann_SJ_{}".format(name), "24:00:00", "40Gb", command, dep=dep)
  return submit_job("run_ann_SJ.sh")

def class_input(out_path, name, assembly, tenX, single,dep=""):
  """Run script to create class input file"""
  command = "python3 scripts/light_class_input.py --outpath {}{}/ --assembly {} --bams ".format(out_path, name, assembly) 
  if single:
    command += "{}{}/2Aligned.out.bam ".format(out_path,name)
  else:
    command += "{}{}/1Aligned.out.bam ".format(out_path,name)
    command += "{}{}/2Aligned.out.bam ".format(out_path,name)
  if tenX:
    command += "--UMI_bar "
  sbatch_file("run_class_input.sh", out_path, name,"class_input_{}".format(name), "48:00:00", "300Gb", command, dep=dep)  # 96:00:00, and 210 Gb for Lu, 100 for others
  return submit_job("run_class_input.sh")

def HISAT_class_input(out_path, name, assembly, gtf_file, tenX, single,dep=""):
  """Run script to create class input file based on HISAT sam file"""
  command = "python3 scripts/create_class_input.py -i {}{}/ -a {} -g {} ".format(out_path, name, assembly, gtf_file)
  if single:
    command += "--single "
  if tenX:
    command += "--tenX"
  sbatch_file("run_HISAT_class_input.sh", out_path, name,"HISAT_class_input_{}".format(name), "24:00:00", "100Gb", command, dep=dep)
  return submit_job("run_HISAT_class_input.sh")

def sam_to_bam(out_path, name, single,dep=""):
  """converts the sam output file by HISAT to a bam file so that it can be read by the class input file script"""
  command = "samtools view -S -b {}{}/2Aligned.out.sam > {}{}/2Aligned.out.bam \n".format(out_path, name, out_path, name)
  if not single:
    command += "samtools view -S -b {}{}/1Aligned.out.sam > {}{}/1Aligned.out.bam".format(out_path, name, out_path, name)
  sbatch_file("run_sam_to_bam.sh", out_path, name,"sam_to_bam_{}".format(name), "24:00:00", "100Gb", command, dep=dep)
  return submit_job("run_sam_to_bam.sh")


def STAR_map(out_path, data_path, name, r_ends, assembly, gzip, cSM, cJOM, aSJMN, cSRGM, sIO, sIB, single, gtf_file, tenX, dep = ""):
  """Run script to perform mapping job for STAR"""
  command = "mkdir -p {}{}\n".format(out_path, name)
  command += "STAR --version\n"
  if single:
    l = 1
  else:
    l = 0
  for i in range(l,2):
    command += "/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 "
    command += "--alignIntronMax 1000000 "
    command += "--genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/{}_index_2.7.1a ".format(assembly)
    if tenX:
      command += "--readFilesIn {}{}_extracted{} ".format(data_path, name, r_ends[i])
    else:
      command += "--readFilesIn {}{}{} ".format(data_path, name, r_ends[i])
    if gzip:
      command += "--readFilesCommand zcat "
    command += "--twopassMode Basic "
    command += "--outFileNamePrefix {}{}/{} ".format(out_path, name, i + 1)
    command += "--outSAMtype BAM Unsorted "
    command += "--chimSegmentMin {} ".format(cSM)
    command += "--outSAMattributes All "
    command += "--chimOutType WithinBAM SoftClip Junctions "
    command += "--chimJunctionOverhangMin {} ".format(cJOM)
    command += "--scoreInsOpen {} ".format(sIO)
    command += "--scoreInsBase {} ".format(sIB) 
    command += "--alignSJstitchMismatchNmax {} -1 {} {} ".format(aSJMN, aSJMN, aSJMN)
    command += "--chimSegmentReadGapMax {} ".format(cSRGM)
    command += "--quantMode GeneCounts "
    command += "--sjdbGTFfile {} ".format(gtf_file)
    command += "--outReadsUnmapped Fastx \n\n"
  sbatch_file("run_map.sh", out_path, name,"map_{}".format(name), "24:00:00", "60Gb", command, dep = dep)
  return submit_job("run_map.sh")

def HISAT_map(out_path, data_path, name, r_ends, assembly, single, tenX, dep = ""):
  """Run script to perform mapping job for HISAT"""
  command = "mkdir -p {}{}\n".format(out_path, name)
  command += "/scratch/PI/horence/Roozbeh/hisat2-2.1.0/hisat2 --version\n"
  if single:
    l = 1
  else:
    l = 0
  for i in range(l,2):
    command += "/scratch/PI/horence/Roozbeh/hisat2-2.1.0/hisat2 -p 4 -q --max-intronlen 1000000 -t --no-unal -k 7 --secondary --met-file {}{}/{}HISAT_alignment_metric.txt".format(out_path, name, i + 1)
    command += "-x /oak/stanford/groups/horence/Roozbeh/single_cell_project/HISAT2/index_files/{}_HISAT2 ".format(assembly)
    if tenX:
      command += "-U {}{}_extracted{} ".format(data_path, name, r_ends[i])
    else:
      command += "-U {}{}{} ".format(data_path, name, r_ends[i])
    command += "-S {}{}/{}Aligned.out.sam \n\n".format(out_path, name, i + 1)
    
  sbatch_file("run_HISAT_map.sh", out_path, name,"HISAT_map_{}".format(name), "12:00:00", "60Gb", command, dep = dep)
  return submit_job("run_HISAT_map.sh")


def submit_job(file_name):
  """Submit sbatch job to cluster"""
  status, job_num = subprocess.getstatusoutput("sbatch {}".format(file_name))
  if status == 0:
    print("{} ({})".format(job_num, file_name))
    return job_num.split()[-1]
  else:
    print("Error submitting job {} {} {}".format(status, job_num, file_name))

def main():

 # parser = argparse.ArgumentParser()
 # parser.add_argument('-s', '--sample', required=True, help='the name of the smartseq sample')
 # args = parser.parse_args()

  chimMultimapNmax = [0]
  chimSegmentMin = [10] 
  chimJunctionOverhangMin = [10]
  alignSJstitchMismatchNmax = [0]
  chimSegmentReadGapMax = [0]
  scoreInsOpen = [-2]
  scoreInsBase = [-2]
  scoreDelOpen = [-2]
  scoreDelBase = [-2]
  include_one_read = True

  # benchmarking
  data_path = "/scratch/PI/horence/Roozbeh/single_cell_project/data/benchmarking/"
  assembly = "hg38"
  run_name = "benchmarking"
  r_ends = ["_2.fastq", "_2.fastq"]
  names = ["SRR6782109", "SRR6782110", "SRR6782111", "SRR6782112", "SRR8606521"]
  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
  single = True
  tenX = False

  
 # Tabula Muris colon
#  data_path = "/scratch/PI/horence/JuliaO/single_cell/data/SRA/19.05.31.GSE109774/"
#  assembly = "mm10"
#  run_name = "GSE109774_colon"
#  r_ends = ["_1.fastq.gz", "_2.fastq.gz"]
#  names = ["SRR65462{}".format(i) for i in range(73,85)]
#  names = ["SRR65462{}".format(i) for i in range(75,76)]
#  single = False
#  tenX = False
#  HISAT = False
#  gtf_file = "/scratch/PI/horence/JuliaO/single_cell/STAR_output/{}_files/{}.gtf".format(assembly, assembly)


# TSP1 10x
  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/bob_10x_TS_data/TSP1_blood_1_redo/TSP1_blood_1_redo_4/"
  assembly = "hg38"
  run_name = "TS_pilot_10X_bob"
  r_ends = ["_R1_001.fastq.gz", "_R2_001.fastq.gz"]
  names = ["TSP1_blood_1_redo_S4"]
  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
  single = True
  tenX = True
  HISAT = False
  bc_pattern = "C"*16 + "N"*10


# CML sample
#  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/CML/"
#  assembly = "hg38"
#  run_name = "CML_2410"
#  r_ends = ["_1.fq.gz", "_2.fq.gz"]
#  names = ["SRR3192410_val"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  tenX = False
#  HISAT = False

#circRNA thirdparty benchmarking
  data_path = "/scratch/PI/horence/Roozbeh/third_party_circ_benchmarking/Ghent-cRNA-137582445/TxDx2016_001_001-271916136/"
  assembly = "hg38"
  run_name = "circRNA_thirdparty_benchmarking_IntronMax_1000000"
  r_ends = ["_R1.fastq.gz", "_R2.fastq.gz"]
  names = ["TxDx2016-001-001_S1_L001"]
  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
  single = False
  tenX = False
  HISAT = True

# STAR_sim
#  data_path = "/scratch/PI/horence/Roozbeh/data/machete_paper/STAR-Fusion_benchmarking_data/sim_101_fastq/"
#  assembly = "hg38"
#  run_name = "sim_101"
#  r_ends = ["_1.fq.renamed.fq.gz", "_2.fq.renamed.fq.gz"]
#  names = ["sim1_reads","sim2_reads","sim3_reads","sim4_reads","sim5_reads"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  HISAT = False
#  tenX = False

#V3 chemistry
#  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_nextgem_fastqs/"
#  assembly = "hg38"
#  run_name = "V3_chemistry_10X"
#  r_ends = ["_R1_001.fastq.gz", "_R2_001.fastq.gz"]
#  names = ["5k_pbmc_v3_nextgem_S1_L001"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = True
#  tenX = False
#  HISAT = False

# SC benchmarking CCLE data
#  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/cell_lines/"
#  assembly = "hg38"
#  run_name = "SC_benchmarking_CCLE"
#  r_ends = ["_1.fq.gz","_2.fq.gz"]
#  names = ["G26203.NCI-H838"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  HISAT = False
#  tenX= False

# SC 10X benchmarking data
#  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/"
#  assembly = "hg38"
#  run_name = "SC_benchmarking_10X_5cl"
#  r_ends = ["_1.fastq","_2.fastq"]
#  names = ["SRR8606521"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = True
#  HISAT = False
#  tenX= True

# DNA_Seq
#  data_path = "/scratch/PI/horence/Roozbeh/data/DNA_Seq/"
#  assembly = "hg38"
#  run_name = "DNA_Seq"
#  r_ends = ["_1.fastq", "_2.fastq"]
#  names = ["SRR027963","SRR078586"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = True
#  tenX = False
#  HISAT = False

#DNA-Seq (1000 Genome)
#  data_path = "/scratch/PI/horence/Roozbeh/data/DNA_Seq/1000_Genome/"
#  assembly = "hg38"
#  run_name = "1000_Genome"
#  r_ends = ["_1.fastq.gz", "_2.fastq.gz"]
#  names = ["SRR9134109","SRR9134112","SRR9644810"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = True
#  tenX = False
#  HISAT = False

#HISAT sim data mismatch
#  data_path = "/scratch/PI/horence/Roozbeh/data/HISAT_sim_data/reads_mismatch/"
#  assembly = "hg38"
#  run_name = "HISAT_sim_data"
#  r_ends = ["_1.fq", "_2.fq"]
#  names = ["reads_mismatch_20M"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  tenX = False
#  HISAT = False

#Lu data
#  data_path = "/oak/stanford/groups/horence/Roozbeh/Lu_data/"
#  assembly = "hg38"
#  run_name = "Lu_data"
#  r_ends = ["_R1.fastq.gz", "_R2.fastq.gz"]
#  names = ["31160_ID1232_1-1A_S1_L002","31161_ID1232_2-1B_S2_L002","31162_ID1232_3-2A_S3_L002","31163_ID1232_4-3A_S4_L002","31164_ID1232_5-4A_S5_L002","31165_ID1232_6-5A_S6_L002"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  tenX = False
#  HISAT = False

#DMD data
#  data_path = "/scratch/PI/horence/Roozbeh/DMD_Artandi/data/191122_NS500615_0903_AHTTK2BGXC/"
#  assembly = "hg38"
#  run_name = "DMD_Artandi"
#  r_ends = ["_R1_001.fastq.gz", "_R2_001.fastq.gz"]
#  names = ["HM3-CCGCGGTT-CTAGCGCT_S2"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  tenX = False
#  HISAT = False

#HISAT sim data perfect
#  data_path = "/scratch/PI/horence/Roozbeh/data/HISAT_sim_data/reads_perfect/"
#  assembly = "hg38"
#  run_name = "HISAT_sim_data"
#  r_ends = ["_1.fq", "_2.fq"]
#  names = ["reads_perfect_20M"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  tenX = False
#  HISAT = False


#Engstrom
#  data_path = "/scratch/PI/horence/Roozbeh/Engstrom/data/"
#  assembly = "hg38"
#  run_name = "Engstrom"
#  r_ends = ["_R1.fq.gz", "_R2.fq.gz"]
#  names = ["Engstrom_sim1_trimmed","Engstrom_sim2_trimmed"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = False
#  tenX = False
#  HISAT = False

#TSP1_redo
#  data_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/"
#  assembly = "hg38"
#  run_name = "TS_pilot_10X_redo"
#  r_ends = ["_R1_001.fastq.gz", "_R2_001.fastq.gz"]
#  names = ["TSP1_muscle_3_S15_L003","TSP1_muscle_3_S15_L004"]
#  gtf_file = "/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
#  single = True
#  tenX = True
#  HISAT = False
#  bc_pattern = "C"*16 + "N"*10


  run_whitelist = False
  run_extract = False
  run_map = False
  run_HISAT_map = True
  run_sam_to_bam = False
  run_star_fusion = False
  run_ann = False
  run_class = False
  run_HISAT_class = True
  run_GLM = True
  

  if not single:
    run_whitelist = False
    run_extract = False
  
  if HISAT:
    run_whitelist = False
    run_extract = False
    run_map = False
    run_star_fusion = False
    run_ann = False
    run_class = False

  if run_HISAT_map:
    run_sam_to_bam = True

  if r_ends[0].split(".")[-1] == "gz":
    gzip = True
  else:
    gzip = False

  for cSM in chimSegmentMin:
    for cJOM in chimJunctionOverhangMin:
      for aSJMN in alignSJstitchMismatchNmax:
        for cSRGM in chimSegmentReadGapMax:
          for sIO in scoreInsOpen:
            for sIB in scoreInsBase:
              for sDO in scoreDelOpen:
                for sDB in scoreDelBase:
              #cond_run_name = run_name + "_cSM_{}_cJOM_{}_aSJMN_{}_cSRGM_{}_sIO_{}_sIB_{}".format(cSM, cJOM, aSJMN, cSRGM, sIO, sIB)
                  cond_run_name = run_name + "_cSM_{}_cJOM_{}_aSJMN_{}_cSRGM_{}".format(cSM, cJOM, aSJMN, cSRGM)
#                  out_path = "/scratch/PI/horence/Roozbeh/single_cell_project/output/{}/".format(cond_run_name)
                  out_path = "/scratch/PI/horence/Roozbeh/single_cell_project/output/{}/".format(cond_run_name)
                  if run_name == "DMD_Artandi":
                    out_path = "/scratch/PI/horence/Roozbeh/DMD_Artandi/{}/".format(cond_run_name)
        
                  curr_run_whitelist = False
                  curr_run_extract = False
                  total_jobs = []
                  total_job_names = []
                  for name in names:
                    jobs = []
                    job_nums = []
              
                    if not os.path.exists("{}{}/log_files".format(out_path, name)):
                      os.makedirs("{}{}/log_files".format(out_path, name))

                    if run_whitelist or curr_run_whitelist:
                      whitelist_jobid = whitelist(data_path,out_path, name, bc_pattern, r_ends)
                      jobs.append("whitelist_{}.{}".format(name, whitelist_jobid))
                      job_nums.append(whitelist_jobid)
                    else:
                      whitelist_jobid = ""
                    if run_extract or curr_run_extract:
                      extract_jobid = extract(out_path, data_path, name, bc_pattern, r_ends, dep = ":".join(job_nums))
                      jobs.append("extract_{}.{}".format(name, extract_jobid))
                      job_nums.append(extract_jobid)
                    else:
                      extract_jobid = ""
                    if run_map:
                      map_jobid = STAR_map(out_path, data_path, name, r_ends, assembly, gzip, cSM, cJOM, aSJMN, cSRGM, sIO, sIB, single, gtf_file, tenX, dep = ":".join(job_nums))
                      jobs.append("map_{}.{}".format(name,map_jobid))
                      job_nums.append(map_jobid)

                    if run_HISAT_map:
                      HISAT_map_jobid = HISAT_map(out_path, data_path, name, r_ends, assembly, single, tenX, dep = ":".join(job_nums))
                      jobs.append("HISAT_map_{}.{}".format(name,HISAT_map_jobid))
                      job_nums.append(HISAT_map_jobid)
                    else:
                      HISAT_map_jobid = ""

                    if run_sam_to_bam:
                      sam_to_bam_jobid = sam_to_bam(out_path, name, single, dep = ":".join(job_nums))
                      jobs.append("sam_to_bam_{}.{}".format(name,HISAT_map_jobid))
                      job_nums.append(sam_to_bam_jobid)
                    else:
                      sam_to_bam_jobid = ""

                    if run_star_fusion:
                      star_fusion_jobid = star_fusion(out_path, name, single, dep=":".join(job_nums))
                      jobs.append("fusion_{}.{}".format(name,star_fusion_jobid))
                      job_nums.append(star_fusion_jobid)
                    else:
                      star_fusion_jobid = ""
        
                    if run_ann:
                      ann_SJ_jobid = ann_SJ(out_path, name, assembly, gtf_file, single, dep = ":".join(job_nums))
                      jobs.append("ann_SJ_{}.{}".format(name,ann_SJ_jobid))
                      job_nums.append(ann_SJ_jobid)
                    else:
                      ann_SJ_jobid =  ""

                    if run_HISAT_class:
                      HISAT_class_input_jobid = HISAT_class_input(out_path, name, assembly, gtf_file, tenX, single, dep=":".join(job_nums))
                      jobs.append("HISAT_class_input_{}.{}".format(name,HISAT_class_input_jobid))
                      job_nums.append(HISAT_class_input_jobid)
                    else:
                      HISAT_class_input_jobid = ""

                    if run_class:
                      class_input_jobid = class_input(out_path, name, assembly, tenX, single,dep=":".join(job_nums))
                      jobs.append("class_input_{}.{}".format(name,class_input_jobid))
                      job_nums.append(class_input_jobid)
                    else:
                      class_input_jobid = ""

                    if run_GLM:
                     GLM_jobid = GLM(out_path, name, single, assembly, dep=":".join(job_nums))
                     jobs.append("GLM_{}.{}".format(name,GLM_jobid))
                     job_nums.append(GLM_jobid)
                    else:
                      GLM_jobid =  ""

main()
