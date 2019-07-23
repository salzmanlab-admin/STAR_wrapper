#!/bin/bash
#
#SBATCH --job-name=fusion_TSP1_muscle_1_S19_L004_R2
#SBATCH --output=job_output/fusion_TSP1_muscle_1_S19_L004_R2.%j.out
#SBATCH --error=job_output/fusion_TSP1_muscle_1_S19_L004_R2.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J    /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_1_S19_L004_R2/2Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_1_S19_L004_R2/star_fusion 
date
