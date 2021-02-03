#!/bin/bash
#
#SBATCH --job-name=whitelist_R_SCV648_4
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/whitelist_R_SCV648_4.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/whitelist_R_SCV648_4.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4
umi_tools whitelist --stdin /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_R1.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --log2stderr > /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_whitelist.txt --plot-prefix=/oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4 
date
