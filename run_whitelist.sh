#!/bin/bash
#
#SBATCH --job-name=whitelist_MLCA_MARTINE_BLOOD_S12_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002/log_files/whitelist_MLCA_MARTINE_BLOOD_S12_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002/log_files/whitelist_MLCA_MARTINE_BLOOD_S12_L002.%j.err
#SBATCH --time=2:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002
umi_tools whitelist --stdin /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_whitelist.txt --plot-prefix=/oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002 
date
