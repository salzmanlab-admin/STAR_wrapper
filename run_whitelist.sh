#!/bin/bash
#
#SBATCH --job-name=whitelist_TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run3/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004/log_files/whitelist_TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run3/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004/log_files/whitelist_TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run3/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004
umi_tools whitelist --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --log2stderr > /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004_whitelist.txt --plot-prefix=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004 
date
