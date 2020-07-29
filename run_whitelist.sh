#!/bin/bash
#
#SBATCH --job-name=whitelist_TSP2_Vasculature_Aorta_10X_1_1_S26_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/whitelist_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/whitelist_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002
umi_tools whitelist --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --log2stderr > /scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_whitelist.txt --plot-prefix=/scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002 
date
