#!/bin/bash
#
#SBATCH --job-name=map_B107809_A15_S135
#SBATCH --output=job_output/map_B107809_A15_S135.%j.out
#SBATCH --error=job_output/map_B107809_A15_S135.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10/B107809_A15_S135
STAR --version
/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/smartseq2/B107809_A15_S135/B107809_A15_S135_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10/B107809_A15_S135/1 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --chimMultimapNmax 10 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 

/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/smartseq2/B107809_A15_S135/B107809_A15_S135_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10/B107809_A15_S135/2 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --chimMultimapNmax 10 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 


date
