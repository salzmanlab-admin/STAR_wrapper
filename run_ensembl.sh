#!/bin/bash
#
#SBATCH --job-name=ensembl_Engstrom_sim1_trimmed
#SBATCH --output=job_output/ensembl_Engstrom_sim1_trimmed.%j.out
#SBATCH --error=job_output/ensembl_Engstrom_sim1_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=25Gb
#SBATCH --dependency=afterok:47840167:47840168:47840169:47840170
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed/  0 
date
