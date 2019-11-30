#!/bin/bash
#
#SBATCH --job-name=map_SRR6782112
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/map_SRR6782112.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/map_SRR6782112.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:55462617:55462618
#SBATCH --kill-on-invalid-dep=yes
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112
STAR --version
/scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /scratch/PI/horence/JuliaO/single_cell/STAR_output/hg38_index_2.7.1a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/benchmarking/SRR6782112_extracted_2.fastq --twopassMode Basic --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
