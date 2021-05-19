#!/bin/bash
#
#SBATCH --job-name=whitelist_SRR8374916
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/mouse_salivary_gland/SRR8374916/log_files/whitelist_SRR8374916.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/mouse_salivary_gland/SRR8374916/log_files/whitelist_SRR8374916.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/mouse_salivary_gland/SRR8374916
umi_tools whitelist --stdin /scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916_1.fastq.gz --bc-pattern=CCCCCCCCCCCCNNNNNNNN --log2stderr > /scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916_whitelist.txt --plot-prefix=/scratch/PI/horence/Roozbeh/single_cell_project/data/Public_data/mouse_salivary_gland/SRR8374916 
date
