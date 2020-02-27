#!/bin/bash
#
#SBATCH --job-name=map_5k_pbmc_v3_S1_L001
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001/log_files/map_5k_pbmc_v3_S1_L001.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001/log_files/map_5k_pbmc_v3_S1_L001.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:62091872:62091875
#SBATCH --kill-on-invalid-dep=yes
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/hg38_index_2.7.1a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/chemistry_check_datasets/5k_pbmc_v3_fastqs/5k_pbmc_v3_S1_L001_extracted_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/V3_chemistry_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/5k_pbmc_v3_S1_L001/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
