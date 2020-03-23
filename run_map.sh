#!/bin/bash
#
#SBATCH --job-name=map_SRR11241254
#SBATCH --output=output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/log_files/map_SRR11241254.%j.out
#SBATCH --error=output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/log_files/map_SRR11241254.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence,owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /scratch/PI/horence/rob/data/covid19/grch38_covid19_star_index --readFilesIn /scratch/PI/horence/rob/data/covid19/fastqs/SRR11241254_1.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 


date
