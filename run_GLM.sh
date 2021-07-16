#!/bin/bash
#
#SBATCH --job-name=GLM_TSP14_Vasculature_CoronaryArteries_10X_1_1_S13
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run1/TSP14_Vasculature_CoronaryArteries_10X_1_1_S13/log_files/GLM_TSP14_Vasculature_CoronaryArteries_10X_1_1_S13.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run1/TSP14_Vasculature_CoronaryArteries_10X_1_1_S13/log_files/GLM_TSP14_Vasculature_CoronaryArteries_10X_1_1_S13.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=350Gb
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run1/TSP14_Vasculature_CoronaryArteries_10X_1_1_S13/ /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf  1  1  1 /oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/ucscGenePfam.txt /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq_exon_bounds.pkl /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq_splices.pkl 
date
