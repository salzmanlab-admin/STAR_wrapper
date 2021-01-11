#!/bin/bash
#
#SBATCH --job-name=map_P9_B003142_S369_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0304/P9_B003142_S369_L002/log_files/map_P9_B003142_S369_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0304/P9_B003142_S369_L002/log_files/map_P9_B003142_S369_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0304/P9_B003142_S369_L002
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --version
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/190422_A00111_0304_AHJ7KTDSXX_Final/fastqs/P9_B003142_S369_L002_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0304/P9_B003142_S369_L002/1 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 

/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/190422_A00111_0304_AHJ7KTDSXX_Final/fastqs/P9_B003142_S369_L002_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0304/P9_B003142_S369_L002/2 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
