#!/bin/bash
#
#SBATCH --job-name=extract_HumanSpermatogonia_17_5
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/spermatogenesis_human_10x/HumanSpermatogonia_17_5/log_files/extract_HumanSpermatogonia_17_5.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/spermatogenesis_human_10x/HumanSpermatogonia_17_5/log_files/extract_HumanSpermatogonia_17_5.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake,horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:10207347
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5_R1.fastq.gz --stdout /scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5_extracted_R1.fastq.gz --read2-in /scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5_R2.fastq.gz --read2-out=/scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5_extracted_R2.fastq.gz --whitelist=/scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5_whitelist.txt --error-correct-cell 
date
