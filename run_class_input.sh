#!/bin/bash
#
#SBATCH --job-name=class_input_TSP2_Kidney_NA_10X_1_2_S2_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun/TSP2_Kidney_NA_10X_1_2_S2_L004/log_files/class_input_TSP2_Kidney_NA_10X_1_2_S2_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun/TSP2_Kidney_NA_10X_1_2_S2_L004/log_files/class_input_TSP2_Kidney_NA_10X_1_2_S2_L004.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=400Gb
date
python3 scripts/light_class_input.py --outpath /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun/TSP2_Kidney_NA_10X_1_2_S2_L004/ --gtf /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --annotator /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq.pkl --bams /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun/TSP2_Kidney_NA_10X_1_2_S2_L004/2Aligned.out.bam --UMI_bar --stranded_library 
date
