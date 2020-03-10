#!/bin/bash
#
#SBATCH --job-name=extract_MLCA_MARTINE_BLOOD_S12_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002/log_files/extract_MLCA_MARTINE_BLOOD_S12_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002/log_files/extract_MLCA_MARTINE_BLOOD_S12_L002.%j.err
#SBATCH --time=20:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:62761743
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_R1_001.fastq.gz --stdout /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_extracted_R1_001.fastq.gz --read2-in /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_R2_001.fastq.gz --read2-out=/oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_whitelist.txt --error-correct-cell 
date
