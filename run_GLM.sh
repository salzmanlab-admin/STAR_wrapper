#!/bin/bash
#
#SBATCH --job-name=GLM_180819_11
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Slide_Puck_180819_11_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/180819_11/log_files/GLM_180819_11.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Slide_Puck_180819_11_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/180819_11/log_files/GLM_180819_11.%j.err
#SBATCH --time=48:00:00
#SBATCH -p horence,owners
#SBATCH --nodes=1
#SBATCH --mem=300Gb
#SBATCH --dependency=afterok:62091598:62091600:62091602:62091604
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Slide_Puck_180819_11_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/180819_11/ hg38  1 
date
