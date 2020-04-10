#!/bin/bash
#
#SBATCH --job-name=whitelist_TSP1_blood_2_redo_S8
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_covid_combined_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_2_redo_S8/log_files/whitelist_TSP1_blood_2_redo_S8.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_covid_combined_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_2_redo_S8/log_files/whitelist_TSP1_blood_2_redo_S8.%j.err
#SBATCH --time=2:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_covid_combined_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_2_redo_S8
umi_tools whitelist --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8_whitelist.txt --plot-prefix=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2_redo/TSP1_blood_2_redo_S8 
date
