#!/bin/bash
#
#SBATCH --job-name=whitelist_5k_pbmc_v3_S1_L001
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001/log_files/whitelist_5k_pbmc_v3_S1_L001.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001/log_files/whitelist_5k_pbmc_v3_S1_L001.%j.err
#SBATCH --time=2:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001
umi_tools whitelist --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_R1.fq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_whitelist.txt --plot-prefix=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001 
date
