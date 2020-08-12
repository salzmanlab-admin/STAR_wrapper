#!/bin/bash
#
#SBATCH --job-name=map_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/map_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/log_files/map_TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165.%j.err
#SBATCH --time=24:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165
STAR --version
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP2_SS2/RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/1 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 

/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/TSP2_SS2/RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Spleen_NA_SS2_B114583_B104854_Granulocyte_G21_S165/2 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
