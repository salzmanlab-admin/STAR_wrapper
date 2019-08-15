#!/bin/bash
#
#SBATCH --job-name=ensembl_TSP1_blood_3_S24_L004
#SBATCH --output=job_output/ensembl_TSP1_blood_3_S24_L004.%j.out
#SBATCH --error=job_output/ensembl_TSP1_blood_3_S24_L004.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=25Gb
#SBATCH --dependency=afterok:48228269
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_3_S24_L004/  1 
date
