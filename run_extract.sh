#!/bin/bash
#
#SBATCH --job-name=extract_SRR8374916
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/mouse_salivary_gland/SRR8374916/log_files/extract_SRR8374916.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/mouse_salivary_gland/SRR8374916/log_files/extract_SRR8374916.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:18805931
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCNNNNNNNN --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916_1.fastq.gz --stdout /scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916_extracted_1.fastq.gz --read2-in /scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916_2.fastq.gz --read2-out=/scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916_extracted_2.fastq.gz --whitelist=/scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916_whitelist.txt --error-correct-cell 
date
