#!/bin/bash
#
#SBATCH --job-name=map_TxDx2016-001-001_S1_L002
#SBATCH --output=output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/map_TxDx2016-001-001_S1_L002.%j.out
#SBATCH --error=output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/map_TxDx2016-001-001_S1_L002.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002
STAR --version
/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/third_party_circ_benchmarking/Ghent-cRNA-137582445/TxDx2016_001_001-271916136/TxDx2016-001-001_S1_L002_R1.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/1 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 

/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/third_party_circ_benchmarking/Ghent-cRNA-137582445/TxDx2016_001_001-271916136/TxDx2016-001-001_S1_L002_R2.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
