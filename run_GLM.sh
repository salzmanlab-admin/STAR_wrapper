#!/bin/bash
#
#SBATCH --job-name=GLM_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003/log_files/GLM_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003/log_files/GLM_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
#SBATCH --dependency=afterok:3344129:3344130:3344131:3344132
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003/ gencode-vH29.SARS-CoV-2_WA1  1 
date
