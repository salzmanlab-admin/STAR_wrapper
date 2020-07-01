#!/bin/bash
#
#SBATCH --job-name=fusion_lungSlice_Pilot2_72h_SARS-CoV-2_Sample_2_S4_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_without_umitools_10x_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot2_72h_SARS-CoV-2_Sample_2_S4_L002/log_files/fusion_lungSlice_Pilot2_72h_SARS-CoV-2_Sample_2_S4_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_without_umitools_10x_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot2_72h_SARS-CoV-2_Sample_2_S4_L002/log_files/fusion_lungSlice_Pilot2_72h_SARS-CoV-2_Sample_2_S4_L002.%j.err
#SBATCH --time=12:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J    /scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_without_umitools_10x_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot2_72h_SARS-CoV-2_Sample_2_S4_L002/2Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_without_umitools_10x_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot2_72h_SARS-CoV-2_Sample_2_S4_L002/star_fusion 
date
