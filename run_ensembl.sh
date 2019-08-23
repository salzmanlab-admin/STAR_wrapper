#!/bin/bash
#
#SBATCH --job-name=ensembl_Engstrom_sim1_trimmed
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim1_trimmed/log_files/ensembl_Engstrom_sim1_trimmed.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim1_trimmed/log_files/ensembl_Engstrom_sim1_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=50Gb
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim1_trimmed/  0 
date
