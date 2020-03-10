#!/bin/bash
#
#SBATCH --job-name=GLM_MLCA_ANTOINE_TRACHEA_S2_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_ANTOINE_TRACHEA_S2_L002/log_files/GLM_MLCA_ANTOINE_TRACHEA_S2_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_ANTOINE_TRACHEA_S2_L002/log_files/GLM_MLCA_ANTOINE_TRACHEA_S2_L002.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=200Gb
#SBATCH --dependency=afterok:62984837
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_ANTOINE_TRACHEA_S2_L002/ Mmur_3.0  1 
date
