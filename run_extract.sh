#!/bin/bash
#
#SBATCH --job-name=extract_SRR6782112
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/extract_SRR6782112.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/extract_SRR6782112.%j.err
#SBATCH --time=20:00:00
#SBATCH -p quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:55700784
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_1.fastq --stdout /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_extracted_1.fastq --read2-in /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_2.fastq --read2-out=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_extracted_2.fastq --filter-cell-barcode --whitelist=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_whitelist.txt --error-correct-cell 
date
