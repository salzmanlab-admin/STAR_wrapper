#!/bin/bash
#
#SBATCH --job-name=extract_TSP1_blood_3_S24_L004
#SBATCH --output=job_output/extract_TSP1_blood_3_S24_L004.%j.out
#SBATCH --error=job_output/extract_TSP1_blood_3_S24_L004.%j.err
#SBATCH --time=20:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:47687795
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_3/TSP1_blood_3_S24_L004_R1_001.fastq.gz --stdout /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_3/TSP1_blood_3_S24_L004_extracted_R1_001.fastq.gz --read2-in /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_3/TSP1_blood_3_S24_L004_R2_001.fastq.gz --read2-out=/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_3/TSP1_blood_3_S24_L004_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_blood_3/TSP1_blood_3_S24_L004_whitelist.txt --error-correct-cell 
date
