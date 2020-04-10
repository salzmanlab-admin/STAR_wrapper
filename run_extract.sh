#!/bin/bash
#
#SBATCH --job-name=extract_TSP1_blood_2_redo_S8
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_covid_combined_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_2_redo_S8/log_files/extract_TSP1_blood_2_redo_S8.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_covid_combined_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_2_redo_S8/log_files/extract_TSP1_blood_2_redo_S8.%j.err
#SBATCH --time=20:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:63854079
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8_R1_001.fastq.gz --stdout /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8_extracted_R1_001.fastq.gz --read2-in /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8_R2_001.fastq.gz --read2-out=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8_whitelist.txt --error-correct-cell 
date
