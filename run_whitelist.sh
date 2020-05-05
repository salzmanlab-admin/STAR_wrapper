#!/bin/bash
#
#SBATCH --job-name=whitelist_TSP2_Vasculature_Aorta_10X_1_2_S27_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/whitelist_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/whitelist_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.err
#SBATCH --time=2:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004
umi_tools whitelist --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_whitelist.txt --plot-prefix=/scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004 
date
