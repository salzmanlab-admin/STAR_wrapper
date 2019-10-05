#!/bin/bash
#
#SBATCH --job-name=ensembl_reads_mismatch_20M
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/ensembl_reads_mismatch_20M.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/ensembl_reads_mismatch_20M.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/  1 
date
