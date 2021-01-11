#!/bin/bash
#
#SBATCH --job-name=whitelist_SRR11073244
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Kidney_fibrosis_mouse_10x/SRR11073244/log_files/whitelist_SRR11073244.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Kidney_fibrosis_mouse_10x/SRR11073244/log_files/whitelist_SRR11073244.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Kidney_fibrosis_mouse_10x/SRR11073244
umi_tools whitelist --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244_1.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN --log2stderr > /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244_whitelist.txt --plot-prefix=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/Public_data/Kidney_fibrosis_mouse/10x_samples/SRR11073244 
date
