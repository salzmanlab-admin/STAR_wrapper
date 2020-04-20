#!/bin/bash
#
#SBATCH --job-name=GLM_TSP1_muscle_3_S15_L004
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/GLM_TSP1_muscle_3_S15_L004.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/GLM_TSP1_muscle_3_S15_L004.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
#SBATCH --dependency=afterok:65633528:65633529
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/ hg38  1 
date
