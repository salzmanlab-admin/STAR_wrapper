#!/bin/bash
#
#SBATCH --job-name=GLM_N18_B002587_S102
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/log_files/GLM_N18_B002587_S102.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/log_files/GLM_N18_B002587_S102.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=200Gb
#SBATCH --dependency=afterok:62098416:62098417:62098418:62098419
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/ hg38  0 
date
