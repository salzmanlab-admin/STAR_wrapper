#!/bin/bash
#
#SBATCH --job-name=GLM_O18_B002592_S30
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/O18_B002592_S30/log_files/GLM_O18_B002592_S30.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/O18_B002592_S30/log_files/GLM_O18_B002592_S30.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=200Gb
#SBATCH --dependency=afterok:62101044:62101045:62101046:62101047
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/O18_B002592_S30/ hg38  0 
date
