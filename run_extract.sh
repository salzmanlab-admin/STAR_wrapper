#!/bin/bash
#
#SBATCH --job-name=extract_SRR11073244
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Kidney_fibrosis_mouse_10x/SRR11073244/log_files/extract_SRR11073244.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Kidney_fibrosis_mouse_10x/SRR11073244/log_files/extract_SRR11073244.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:12142026
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244_1.fastq.gz --stdout /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244_extracted_1.fastq.gz --read2-in /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244_2.fastq.gz --read2-out=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244_extracted_2.fastq.gz --whitelist=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244_whitelist.txt --error-correct-cell 
date
