#!/bin/bash
#
#SBATCH --job-name=map_Engstrom_sim1_trimmed
#SBATCH --output=job_output/map_Engstrom_sim1_trimmed.%j.out
#SBATCH --error=job_output/map_Engstrom_sim1_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed
STAR --version
/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/data/Engstrom/Engstrom_sim1_trimmed_R1.fq --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed/1 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen 0 --scoreInsBase 0 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 

/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/data/Engstrom/Engstrom_sim1_trimmed_R2.fq --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen 0 --scoreInsBase 0 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --outReadsUnmapped Fastx 


date
