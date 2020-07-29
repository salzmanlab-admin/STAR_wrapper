#!/bin/bash
#
#SBATCH --job-name=GLM_TSP2_Vasculature_Aorta_10X_1_1_S26_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/GLM_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/GLM_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=150Gb
#SBATCH --dependency=afterok:4815815:4815816:4815817:4815818
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/ /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf  1 /oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/ucscGenePfam.txt /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_RefSeq_exon_bounds.pkl /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_RefSeq_splices.pkl 
date
