#!/bin/bash
#
#SBATCH --job-name=HISAT_map_reads_perfect_20M
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M/log_files/HISAT_map_reads_perfect_20M.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M/log_files/HISAT_map_reads_perfect_20M.%j.err
#SBATCH --time=12:00:00
#SBATCH -p quake
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M
/scratch/PI/horence/Roozbeh/hisat2-2.1.0/hisat2 --version
/scratch/PI/horence/Roozbeh/hisat2-2.1.0/hisat2 -p 4 -q --max-intronlen 1000000 -t --no-unal -k 7 --secondary --met-file /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M/2HISAT_alignment_metric.txt-x /oak/stanford/groups/horence/Roozbeh/single_cell_project/HISAT2/index_files/hg38_HISAT2 -U /scratch/PI/horence/Roozbeh/data/HISAT_sim_data/reads_perfect/reads_perfect_20M_2.fq -S /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_HISAT_SE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_perfect_20M/2Aligned.out.sam 


date
