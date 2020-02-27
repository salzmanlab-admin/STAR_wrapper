#!/bin/bash
#
#SBATCH --job-name=map_N22_B001234_S154
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154/log_files/map_N22_B001234_S154.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154/log_files/map_N22_B001234_S154.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/hg38_index_2.7.1a --readFilesIn /oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/180301_A00111_0106_AH3K7NDSXX_Final/fastqs/N22_B001234_S154_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154/1 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 

/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/hg38_index_2.7.1a --readFilesIn /oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/180301_A00111_0106_AH3K7NDSXX_Final/fastqs/N22_B001234_S154_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
