#!/bin/bash
#
#SBATCH --job-name=fusion_TSP1_muscle_3_S15_L004
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/fusion_TSP1_muscle_3_S15_L004.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/fusion_TSP1_muscle_3_S15_L004.%j.err
#SBATCH --time=12:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J    /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/2Chimeric.out.junction --output_dir /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/star_fusion 
date
