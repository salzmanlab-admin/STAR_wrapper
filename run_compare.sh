#!/bin/bash
#
#SBATCH --job-name=compare_B107809_N4_S123
#SBATCH --output=job_output/compare_B107809_N4_S123.%j.out
#SBATCH --error=job_output/compare_B107809_N4_S123.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=25Gb
#SBATCH --dependency=afterok:48081054:48081055
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/compare_class_input_STARchimOut.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107809_N4_S123/  0 
date
