#!/bin/bash
#
#SBATCH --job-name=map_SRR7547691
#SBATCH --output=job_output/map_SRR7547691.%j.out
#SBATCH --error=job_output/map_SRR7547691.%j.err
#SBATCH --time=2:00:00
#SBATCH --qos=normal
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR7547691
STAR --version
STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/benchmarking/SRR7547691_2.fastq --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR7547691/2 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --outReadsUnmapped Fastx 


date
