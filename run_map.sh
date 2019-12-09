#!/bin/bash
#
#SBATCH --job-name=map_B107811_P4_S249
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/log_files/map_B107811_P4_S249.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/log_files/map_B107811_P4_S249.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.2b/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/hg38_index_2.7.1a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/smartseq2/B107811_P4_S249/B107811_P4_S249_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/1 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutJunctionFormat 1 --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 

/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.2b/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/hg38_index_2.7.1a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/smartseq2/B107811_P4_S249/B107811_P4_S249_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutJunctionFormat 1 --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
