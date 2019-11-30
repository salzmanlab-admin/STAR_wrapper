#!/bin/bash
#
#SBATCH --job-name=HISAT_class_input_reads_perfect_20M
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M/log_files/HISAT_class_input_reads_perfect_20M.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M/log_files/HISAT_class_input_reads_perfect_20M.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake
#SBATCH --nodes=1
#SBATCH --mem=100Gb
#SBATCH --dependency=afterok:55140842:55140846
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_class_input.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --single 
date
