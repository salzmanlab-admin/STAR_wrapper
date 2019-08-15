#!/bin/bash
#
#SBATCH --job-name=whitelist_TSP1_blood_2_S23_L004
#SBATCH --output=job_output/whitelist_TSP1_blood_2_S23_L004.%j.out
#SBATCH --error=job_output/whitelist_TSP1_blood_2_S23_L004.%j.err
#SBATCH --time=2:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_2_S23_L004
umi_tools whitelist --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2/TSP1_blood_2_S23_L004_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2/TSP1_blood_2_S23_L004_whitelist.txt --plot-prefix=/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_2/TSP1_blood_2_S23_L004 --knee-method=density 
date
