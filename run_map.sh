#!/bin/bash
#
#SBATCH --job-name=map_MLCA_MARTINE_BLOOD_S12_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002/log_files/map_MLCA_MARTINE_BLOOD_S12_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002/log_files/map_MLCA_MARTINE_BLOOD_S12_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:62761743:62761744
#SBATCH --kill-on-invalid-dep=yes
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/Mmur_3.0_index_2.7.1a --readFilesIn /oak/stanford/groups/krasnow/MLCA/data10X/rawdata/Martine_10X/Martine_Blood_fastq/MLCA_MARTINE_BLOOD_S12_L002_extracted_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_MARTINE_BLOOD_S12_L002/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/Roozbeh/single_cell_project/Lemur_genome/Kransow_reference/ref_Mmur_3.0.gtf --outReadsUnmapped Fastx 


date
