#!/bin/bash
#
#SBATCH --job-name=ann_SJ_TSP2_Vasculature_Aorta_10X_1_2_S27_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/ann_SJ_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/ann_SJ_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:66637353:66637354:66637355:66637356
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --single 
date
