#!/bin/bash
#
#SBATCH --job-name=class_input_TSP2_Vasculature_Aorta_10X_1_1_S26_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/class_input_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/class_input_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=150Gb
#SBATCH --dependency=afterok:4815815:4815816:4815817
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/ --gtf /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --annotator /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38.pkl --bams /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/2Aligned.out.bam --UMI_bar --stranded_library 
date
