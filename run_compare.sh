#!/bin/bash
#
#SBATCH --job-name=compare_B107809_A15_S135
#SBATCH --output=job_output/compare_B107809_A15_S135.%j.out
#SBATCH --error=job_output/compare_B107809_A15_S135.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=25Gb
#SBATCH --dependency=afterok:46845426:46845429:46845430:46845432:46845434
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/compare_class_input_STARchimOut.R output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10/B107809_A15_S135/  0 
date
