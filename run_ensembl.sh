#!/bin/bash
#
#SBATCH --job-name=ensembl_B107809_N5_S272
#SBATCH --output=job_output/ensembl_B107809_N5_S272.%j.out
#SBATCH --error=job_output/ensembl_B107809_N5_S272.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=25Gb
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107809_N5_S272/  hg38 0 
date
