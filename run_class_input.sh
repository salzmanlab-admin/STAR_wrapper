#!/bin/bash
#
#SBATCH --job-name=class_input_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/class_input_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/class_input_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.err
#SBATCH --time=48:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=150Gb
#SBATCH --dependency=afterok:16156987:16156988
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/ --gtf /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --annotator /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38.pkl --bams /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/1Aligned.out.bam /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/2Aligned.out.bam --stranded_library --paired 
date
