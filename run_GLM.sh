#!/bin/bash
#
#SBATCH --job-name=GLM_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/GLM_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/GLM_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.err
#SBATCH --time=48:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=150Gb
#SBATCH --dependency=afterok:16156987:16156988:16156989
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/ /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf  0 /oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/ucscGenePfam.txt /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_RefSeq_exon_bounds.pkl /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_RefSeq_splices.pkl 
date
