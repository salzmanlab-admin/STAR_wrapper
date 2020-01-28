#!/bin/bash
#
#SBATCH --job-name=GLM_P3_8_S16_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_180607_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P3_8_S16_L002/log_files/GLM_P3_8_S16_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_180607_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P3_8_S16_L002/log_files/GLM_P3_8_S16_L002.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=300Gb
date
Rscript scripts/GLM_script.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_180607_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P3_8_S16_L002/  1 
date
