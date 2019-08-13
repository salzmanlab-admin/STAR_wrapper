#!/bin/bash
#
#SBATCH --job-name=ensembl_B107809_N5_S124
#SBATCH --output=job_output/ensembl_B107809_N5_S124.%j.out
#SBATCH --error=job_output/ensembl_B107809_N5_S124.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=25Gb
#SBATCH --dependency=afterok:48081061
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107809_N5_S124/  0 
date
