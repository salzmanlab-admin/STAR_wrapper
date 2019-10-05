#!/bin/bash
#
#SBATCH --job-name=ensembl_sim2_reads
#SBATCH --output=output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/log_files/ensembl_sim2_reads.%j.out
#SBATCH --error=output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/log_files/ensembl_sim2_reads.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:52051780:52051781
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/add_ensembl_id.R output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/  0 
date
