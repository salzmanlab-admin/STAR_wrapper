#!/bin/bash
#
#SBATCH --job-name=map_TSP2_Vasculature_Aorta_10X_1_2_S27_L004
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/map_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/log_files/map_TSP2_Vasculature_Aorta_10X_1_2_S27_L004.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:66637353:66637354
#SBATCH --kill-on-invalid-dep=yes
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/TABULA_SAPIENS_PILOT_2/TSP2_Vasculature_Aorta_10X_1_2_S27_L004_extracted_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_2_S27_L004/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
