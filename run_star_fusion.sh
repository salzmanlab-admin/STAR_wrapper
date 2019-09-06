#!/bin/bash
#
#SBATCH --job-name=fusion_Engstrom_sim2_trimmed
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_newgtf_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim2_trimmed/log_files/fusion_Engstrom_sim2_trimmed.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_newgtf_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim2_trimmed/log_files/fusion_Engstrom_sim2_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:49580130
#SBATCH --kill-on-invalid-dep=yes
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J  /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_newgtf_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim2_trimmed/1Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_newgtf_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim2_trimmed/star_fusion 
date
