#!/bin/bash
#
#SBATCH --job-name=extract_TSP1_muscle_1_S19_L003
#SBATCH --output=job_output/extract_TSP1_muscle_1_S19_L003.%j.out
#SBATCH --error=job_output/extract_TSP1_muscle_1_S19_L003.%j.err
#SBATCH --time=20:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:46723842
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003_R1_001.fastq.gz --stdout /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003_extracted_R1_001.fastq.gz --read2-in /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003_R2_001.fastq.gz --read2-out=/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003_extracted_R2_001.fastq.gz --filter-cell-barcode --whitelist=/scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_muscle_1/TSP1_muscle_1_S19_L003_whitelist.txt --error-correct-cell 
date
