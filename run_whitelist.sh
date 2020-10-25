#!/bin/bash
#
#SBATCH --job-name=whitelist_HumanSpermatogonia_17_5
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/spermatogenesis_human_10x/HumanSpermatogonia_17_5/log_files/whitelist_HumanSpermatogonia_17_5.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/spermatogenesis_human_10x/HumanSpermatogonia_17_5/log_files/whitelist_HumanSpermatogonia_17_5.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake,horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/spermatogenesis_human_10x/HumanSpermatogonia_17_5
umi_tools whitelist --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5_R1.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5_whitelist.txt --plot-prefix=/scratch/PI/horence/Roozbeh/single_cell_project/data/spermatogenesis/10x_data/human/HumanSpermatogonia_17_5/HumanSpermatogonia_17_5 
date
