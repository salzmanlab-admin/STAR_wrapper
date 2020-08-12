#!/bin/bash
#
#SBATCH --job-name=fusion_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/fusion_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/fusion_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:16156987
#SBATCH --kill-on-invalid-dep=yes
date
/scg/apps/software/star-fusion/1.8.1/STAR-Fusion --genome_lib_dir  /oak/stanford/groups/horence/Roozbeh/software/STAR-Fusion.v1.9.0/GRCh38_gencode_v33_CTAT_lib_Apr062020.plug-n-play/ctat_genome_lib_build_dir/ -J  /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/1Chimeric.out.junction --output_dir /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/star_fusion 
date
