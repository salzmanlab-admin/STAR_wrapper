#!/bin/bash
#
#SBATCH --job-name=compare_SRR078586
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/log_files/compare_SRR078586.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/log_files/compare_SRR078586.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:49931835:49931836:49931838
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/compare_class_input_STARchimOut.R /scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/  1 
date
