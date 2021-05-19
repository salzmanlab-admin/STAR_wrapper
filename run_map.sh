#!/bin/bash
#
#SBATCH --job-name=map_sim_20M
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_mismatch/sim_20M/log_files/map_sim_20M.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_mismatch/sim_20M/log_files/map_sim_20M.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_mismatch/sim_20M
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --version
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/HISAT/reads_mismatch/sim_20M_1.fq --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_mismatch/sim_20M/1 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 

/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/HISAT/reads_mismatch/sim_20M_2.fq --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HISAT_mismatch/sim_20M/2 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
