#!/bin/bash
#
#SBATCH --job-name=whitelist_TSP1_muscle_1_S19_L003
#SBATCH --output=job_output/whitelist_TSP1_muscle_1_S19_L003.%j.out
#SBATCH --error=job_output/whitelist_TSP1_muscle_1_S19_L003.%j.err
#SBATCH --time=2:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p output/TS_pilot_10X_muscle_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_1_S19_L003
umi_tools whitelist --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003_whitelist.txt --plot-prefix=/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003
date
