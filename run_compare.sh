#!/bin/bash
#
#SBATCH --job-name=compare_TSP1_muscle_3_S21_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S21_L004/log_files/compare_TSP1_muscle_3_S21_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S21_L004/log_files/compare_TSP1_muscle_3_S21_L004.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
date
Rscript scripts/compare_class_input_STARchimOut.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S21_L004/  1 
date
