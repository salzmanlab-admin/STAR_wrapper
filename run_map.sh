#!/bin/bash
#
#SBATCH --job-name=map_R_SCV648_4
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/map_R_SCV648_4.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/map_R_SCV648_4.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:15683297:15683299
#SBATCH --kill-on-invalid-dep=yes
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --version
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/human/hg38_ERCC_STAR_2.7.5.a --readFilesIn /oak/stanford/groups/horence/Roozbeh/single_cell_project/data/minor_intron/R_SCV648/R_SCV648_4_extracted_R2.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/2 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --outReadsUnmapped Fastx 


date
