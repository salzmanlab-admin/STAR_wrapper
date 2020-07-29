#!/bin/bash
#
#SBATCH --job-name=fusion_TSP2_Kidney_NA_SS2_B113455_B104861_Stromal_J9_S225
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Kidney_NA_SS2_B113455_B104861_Stromal_J9_S225/log_files/fusion_TSP2_Kidney_NA_SS2_B113455_B104861_Stromal_J9_S225.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Kidney_NA_SS2_B113455_B104861_Stromal_J9_S225/log_files/fusion_TSP2_Kidney_NA_SS2_B113455_B104861_Stromal_J9_S225.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:16054298
#SBATCH --kill-on-invalid-dep=yes
date
/scg/apps/software/star-fusion/1.8.1/STAR-Fusion --genome_lib_dir  /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-Fusion/GRCh38_gencode_v31_CTAT_lib_Oct012019.plug-n-play/ctat_genome_lib_build_dir/ -J  /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Kidney_NA_SS2_B113455_B104861_Stromal_J9_S225/1Chimeric.out.junction --output_dir /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Kidney_NA_SS2_B113455_B104861_Stromal_J9_S225/star_fusion 
date
