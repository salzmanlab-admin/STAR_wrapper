#!/bin/bash
#
#SBATCH --job-name=map_SRR6546284
#SBATCH --output=job_output/map_SRR6546284.%j.out
#SBATCH --error=job_output/map_SRR6546284.%j.err
#SBATCH --time=2:00:00
#SBATCH --qos=normal
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_1_cSRGM_3/SRR6546284
STAR --version
STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/mm10_index_2.7.1a --readFilesIn /scratch/PI/horence/JuliaO/single_cell/data/SRA/19.05.31.GSE109774/SRR6546284_1.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_1_cSRGM_3/SRR6546284/1 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --alignSJstitchMismatchNmax 1 -1 1 1 --chimSegmentReadGapMax 3 --outReadsUnmapped Fastx 

STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/mm10_index_2.7.1a --readFilesIn /scratch/PI/horence/JuliaO/single_cell/data/SRA/19.05.31.GSE109774/SRR6546284_2.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_1_cSRGM_3/SRR6546284/2 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --alignSJstitchMismatchNmax 1 -1 1 1 --chimSegmentReadGapMax 3 --outReadsUnmapped Fastx 


date
