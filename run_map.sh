#!/bin/bash
#
#SBATCH --job-name=map_TSP2_Vasculature_Aorta_10X_1_1_S26_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/map_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/log_files/map_TSP2_Vasculature_Aorta_10X_1_1_S26_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:4815815:4815816
#SBATCH --kill-on-invalid-dep=yes
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/sicilian_indices/hg38_covid19_ercc_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/TSP2_NovaSeq_Rerun/TSP2_Vasculature_Aorta_10X_1_1_S26_L002_extracted_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/TSP2_10X_rerun_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP2_Vasculature_Aorta_10X_1_1_S26_L002/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 20 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
