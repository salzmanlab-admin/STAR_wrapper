#!/bin/bash
#
#SBATCH --job-name=modify_B107819_B18_S41
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107819_B18_S41/log_files/modify_B107819_B18_S41.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107819_B18_S41/log_files/modify_B107819_B18_S41.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:12149859:12149860:12149861:12149862
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/modify_junction_ids.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107819_B18_S41/ 
date
