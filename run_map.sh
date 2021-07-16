#!/bin/bash
#
#SBATCH --job-name=map_TSP14_Vasculature_AortaVeneCava_10X_1_1_S12
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run1/TSP14_Vasculature_AortaVeneCava_10X_1_1_S12/log_files/map_TSP14_Vasculature_AortaVeneCava_10X_1_1_S12.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run1/TSP14_Vasculature_AortaVeneCava_10X_1_1_S12/log_files/map_TSP14_Vasculature_AortaVeneCava_10X_1_1_S12.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run1/TSP14_Vasculature_AortaVeneCava_10X_1_1_S12
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --version
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP14/TSP14_10X_Run1/TSP14_Vasculature_AortaVeneCava_10X_1_1_S12_extracted_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP14_10X_Run1/TSP14_Vasculature_AortaVeneCava_10X_1_1_S12/2 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --limitOutSJcollapsed 2000000 --limitSjdbInsertNsj 1100000--sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
