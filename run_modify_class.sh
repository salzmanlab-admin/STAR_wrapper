#!/bin/bash
#
#SBATCH --job-name=modify_B107924_N14_S60
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107924_N14_S60/log_files/modify_B107924_N14_S60.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107924_N14_S60/log_files/modify_B107924_N14_S60.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:54676561:54676563:54676567:54676569
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/modify_junction_ids.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107924_N14_S60/ 
date
