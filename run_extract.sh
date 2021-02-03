#!/bin/bash
#
#SBATCH --job-name=extract_R_SCV648_4
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/extract_R_SCV648_4.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/extract_R_SCV648_4.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:15683297
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_R1.fastq.gz --stdout /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_extracted_R1.fastq.gz --read2-in /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_R2.fastq.gz --read2-out=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_extracted_R2.fastq.gz --whitelist=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_whitelist.txt --error-correct-cell 
date
