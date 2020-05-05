#!/bin/bash
#
#SBATCH --job-name=fusion_TSP2_Vasculature_Aorta_10X_1_2_S27_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/fusion_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/fusion_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.err
#SBATCH --time=12:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:66637353:66637354:66637355
#SBATCH --kill-on-invalid-dep=yes
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J    /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/2Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/star_fusion 
date
