#!/bin/bash
#
#SBATCH --job-name=GLM_TSP1_muscle_3_S15_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP1_10X_redo/TSP1_muscle_3_S15_L004/log_files/GLM_TSP1_muscle_3_S15_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP1_10X_redo/TSP1_muscle_3_S15_L004/log_files/GLM_TSP1_muscle_3_S15_L004.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=150Gb
#SBATCH --dependency=afterok:23360376
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP1_10X_redo/TSP1_muscle_3_S15_L004/ /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf  1  1  1 /oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/ucscGenePfam.txt /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq_exon_bounds.pkl /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq_splices.pkl 
date
