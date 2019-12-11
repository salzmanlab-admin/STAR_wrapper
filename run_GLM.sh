#!/bin/bash
#
#SBATCH --job-name=GLM_TxDx2016-001-001_S1_L001
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_IntronMax_1000000_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L001/log_files/GLM_TxDx2016-001-001_S1_L001.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_IntronMax_1000000_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L001/log_files/GLM_TxDx2016-001-001_S1_L001.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake
#SBATCH --nodes=1
#SBATCH --mem=200Gb
#SBATCH --dependency=afterok:56263464:56263465:56263466
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_IntronMax_1000000_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L001/  0 
date
