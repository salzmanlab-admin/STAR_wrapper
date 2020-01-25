#!/bin/bash
#
#SBATCH --job-name=extract_10X_P8_1_S2_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Stumpy_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/10X_P8_1_S2_L002/log_files/extract_10X_P8_1_S2_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Stumpy_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/10X_P8_1_S2_L002/log_files/extract_10X_P8_1_S2_L002.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:57730239
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002_R1_001.fastq.gz --stdout /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002_extracted_R1_001.fastq.gz --read2-in /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002_R2_001.fastq.gz --read2-out=/oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002_whitelist.txt --error-correct-cell 
date
