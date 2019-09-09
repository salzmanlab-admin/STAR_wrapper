#!/bin/bash
#
#SBATCH --job-name=map_reads_mismatch_20M
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/map_reads_mismatch_20M.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/map_reads_mismatch_20M.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M
STAR --version
/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/data/HISAT_sim_data/reads_mismatch/reads_mismatch_20M_1.fq --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/1 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 

/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /scratch/PI/horence/Roozbeh/data/HISAT_sim_data/reads_mismatch/reads_mismatch_20M_2.fq --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
