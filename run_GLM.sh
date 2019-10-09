#!/bin/bash
#
#SBATCH --job-name=GLM_CMLUConn_SRR3192410_trimmed
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/GLM_CMLUConn_SRR3192410_trimmed.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/GLM_CMLUConn_SRR3192410_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=70Gb
#SBATCH --dependency=afterok:52337982:52337983
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script.R /scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/  0 
date
