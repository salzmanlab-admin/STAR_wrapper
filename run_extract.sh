#!/bin/bash
#
#SBATCH --job-name=extract_TSP2_Vasculature_Aorta_10X_1_1_S26_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/extract_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/extract_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:4815815
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_R1_001.fastq.gz --stdout /scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_extracted_R1_001.fastq.gz --read2-in /scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_R2_001.fastq.gz --read2-out=/scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_whitelist.txt --error-correct-cell 
date
