#!/bin/bash
#
#SBATCH --job-name=sam_to_bam_SRR9644810
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/log_files/sam_to_bam_SRR9644810.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/log_files/sam_to_bam_SRR9644810.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=100Gb
#SBATCH --dependency=afterok:53869198
#SBATCH --kill-on-invalid-dep=yes
date
samtools view -S -b /scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/2Aligned.out.sam > /scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/2Aligned.out.bam 

date
