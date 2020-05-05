#!/bin/bash
#
#SBATCH --job-name=extract_TSP2_Vasculature_Aorta_10X_1_2_S27_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/extract_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/extract_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.err
#SBATCH --time=20:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:66637353
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_R1_001.fastq.gz --stdout /scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_extracted_R1_001.fastq.gz --read2-in /scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_R2_001.fastq.gz --read2-out=/scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_whitelist.txt --error-correct-cell 
date
