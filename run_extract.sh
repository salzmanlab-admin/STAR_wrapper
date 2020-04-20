#!/bin/bash
#
#SBATCH --job-name=extract_TSP1_muscle_3_S15_L004
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/extract_TSP1_muscle_3_S15_L004.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/extract_TSP1_muscle_3_S15_L004.%j.err
#SBATCH --time=20:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:65410318
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004_R1_001.fastq.gz --stdout /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004_extracted_R1_001.fastq.gz --read2-in /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004_R2_001.fastq.gz --read2-out=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004_whitelist.txt --error-correct-cell 
date
