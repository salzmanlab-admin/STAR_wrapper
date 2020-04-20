#!/bin/bash
#
#SBATCH --job-name=whitelist_TSP1_muscle_3_S15_L004
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/whitelist_TSP1_muscle_3_S15_L004.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004/log_files/whitelist_TSP1_muscle_3_S15_L004.%j.err
#SBATCH --time=2:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_3_S15_L004
umi_tools whitelist --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004_whitelist.txt --plot-prefix=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP1_redo/TSP1_muscle_3/TSP1_muscle_3_S15_L004 
date
