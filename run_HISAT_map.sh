#!/bin/bash
#
#SBATCH --job-name=HISAT_map_SRR9644810
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/log_files/HISAT_map_SRR9644810.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/log_files/HISAT_map_SRR9644810.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810
/scratch/PI/horence/Roozbeh/hisat2-2.1.0/hisat2 --version
/scratch/PI/horence/Roozbeh/hisat2-2.1.0/hisat2 -p 4 -q --max-intronlen 1000000 -t --no-unal -k 7 --met-file /scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/2HISAT_alignment_metric.txt-x /oak/stanford/groups/horence/Roozbeh/single_cell_project/HISAT2/index_files/hg38_HISAT2 -U /scratch/PI/horence/Roozbeh/data/DNA_Seq/1000_Genome/SRR9644810_2.fastq.gz -S /scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/2Aligned.out.sam 
date
