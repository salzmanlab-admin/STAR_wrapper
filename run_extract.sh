#!/bin/bash
#
#SBATCH --job-name=extract_TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run3/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004/log_files/extract_TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run3/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004/log_files/extract_TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:28148461
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004_R1_001.fastq.gz --stdout /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004_extracted_R1_001.fastq.gz --read2-in /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004_R2_001.fastq.gz --read2-out=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004_extracted_R2_001.fastq.gz --whitelist=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_TSP15_10X_Run3/Tabula_Sapiens/TSP14_SalivaryGland_Submandibular_10X_1_1_S13_L004_whitelist.txt --error-correct-cell 
date
