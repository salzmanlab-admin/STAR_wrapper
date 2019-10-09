#!/bin/bash
#
#SBATCH --job-name=compare_CMLUConn_SRR3192410_trimmed
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/compare_CMLUConn_SRR3192410_trimmed.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/compare_CMLUConn_SRR3192410_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:52337982
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/compare_class_input_STARchimOut.R /scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/  0 
date
