#!/bin/bash
#
#SBATCH --job-name=GLM_Engstrom_sim1_trimmed
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim1_trimmed/log_files/GLM_Engstrom_sim1_trimmed.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim1_trimmed/log_files/GLM_Engstrom_sim1_trimmed.%j.err
#SBATCH --time=6:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=70Gb
#SBATCH --dependency=afterok:48380591:48380592
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script.R /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim1_trimmed/  0 
date
