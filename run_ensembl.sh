#!/bin/bash
#
#SBATCH --job-name=ensembl_SRR078586
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/log_files/ensembl_SRR078586.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/log_files/ensembl_SRR078586.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:49988629
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/  1 
date
