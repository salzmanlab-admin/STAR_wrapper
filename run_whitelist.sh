#!/bin/bash
#
#SBATCH --job-name=whitelist_10X_P8_1_S2_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Stumpy_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/10X_P8_1_S2_L002/log_files/whitelist_10X_P8_1_S2_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Stumpy_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/10X_P8_1_S2_L002/log_files/whitelist_10X_P8_1_S2_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Stumpy_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/10X_P8_1_S2_L002
umi_tools whitelist --stdin /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002_whitelist.txt --plot-prefix=/oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Stumpy_10X/Stumpy_Heart_10X_fastq/10X_P8_1_S2_L002 --set-cell-number=5000
date
