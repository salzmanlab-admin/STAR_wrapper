#!/bin/bash
#
#SBATCH --job-name=ensembl_CMLUConn_SRR3192410_trimmed
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/ensembl_CMLUConn_SRR3192410_trimmed.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/ensembl_CMLUConn_SRR3192410_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/  0 
date
