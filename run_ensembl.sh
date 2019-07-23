#!/bin/bash
#
#SBATCH --job-name=ensembl_TSP1_muscle_1_S19_L004_R2
#SBATCH --output=job_output/ensembl_TSP1_muscle_1_S19_L004_R2.%j.out
#SBATCH --error=job_output/ensembl_TSP1_muscle_1_S19_L004_R2.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=25Gb
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_1_S19_L004_R2/  1 
date
