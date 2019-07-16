#!/bin/bash
#
#SBATCH --job-name=map_B107827_C18_S202
#SBATCH --output=job_output/map_B107827_C18_S202.%j.out
#SBATCH --error=job_output/map_B107827_C18_S202.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107827_C18_S202
STAR --version
/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/smartseq2/pilot/B107827_C18_S202/B107827_C18_S202_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107827_C18_S202/1 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 

/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/smartseq2/pilot/B107827_C18_S202/B107827_C18_S202_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107827_C18_S202/2 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 


date
