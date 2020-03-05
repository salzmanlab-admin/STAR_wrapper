#!/bin/bash
#
#SBATCH --job-name=extract_5k_pbmc_v3_S1_L001
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001/log_files/extract_5k_pbmc_v3_S1_L001.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001/log_files/extract_5k_pbmc_v3_S1_L001.%j.err
#SBATCH --time=20:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:62113224
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_R1.fq.gz --stdout /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_extracted_R1.fq.gz --read2-in /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_R2.fq.gz --read2-out=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_extracted_R2.fq.gz --filter-cell-barcode --whitelist=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_whitelist.txt --error-correct-cell 
date
