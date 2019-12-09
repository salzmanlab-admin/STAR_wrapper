#!/bin/bash
#
#SBATCH --job-name=compare_B107811_P4_S249
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/log_files/compare_B107811_P4_S249.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/log_files/compare_B107811_P4_S249.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:13005642:13005643:13005644:13005645:13005646:13005647
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/compare_class_input_STARchimOut.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/  0 
date
