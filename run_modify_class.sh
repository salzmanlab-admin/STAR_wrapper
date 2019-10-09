#!/bin/bash
#
#SBATCH --job-name=modify_TxDx2016-001-001_S1_L001
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L001/log_files/modify_TxDx2016-001-001_S1_L001.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L001/log_files/modify_TxDx2016-001-001_S1_L001.%j.err
#SBATCH --time=12:00:00
#SBATCH -p bigmem
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:52314009
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/modify_junction_ids.R /scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L001/ 
date
