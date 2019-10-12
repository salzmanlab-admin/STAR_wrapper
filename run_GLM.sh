#!/bin/bash
#
#SBATCH --job-name=GLM_B107817_K8_S6
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107817_K8_S6/log_files/GLM_B107817_K8_S6.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107817_K8_S6/log_files/GLM_B107817_K8_S6.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=70Gb
#SBATCH --dependency=afterok:52568323:52568351:52568352:52568353
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107817_K8_S6/  0 
date
