#!/bin/bash
#
#SBATCH --job-name=map_TSP1_endopancreas_2_S8_L004_R2
#SBATCH --output=job_output/map_TSP1_endopancreas_2_S8_L004_R2.%j.out
#SBATCH --error=job_output/map_TSP1_endopancreas_2_S8_L004_R2.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_demultiplexed_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_endopancreas_2_S8_L004_R2
STAR --version
/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/single_cell_project/data/tabula_sapiens/pilot/raw_data/10X/TSP1_endopancreas_2/TSP1_endopancreas_2_S8_L004_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_demultiplexed_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_endopancreas_2_S8_L004_R2/2 --outSAMtype SAM --chimSegmentMin 10 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 10 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 


date
