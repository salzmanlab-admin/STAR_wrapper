#!/bin/bash
#
#SBATCH --job-name=whitelist_SRR6782112
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/whitelist_SRR6782112.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/whitelist_SRR6782112.%j.err
#SBATCH --time=2:00:00
#SBATCH -p quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112
umi_tools whitelist --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_1.fastq --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_whitelist.txt --plot-prefix=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112 
date
