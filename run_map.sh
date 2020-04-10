#!/bin/bash
#
#SBATCH --job-name=map_MAA001665_B112513_P9_S369
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369/log_files/map_MAA001665_B112513_P9_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369/log_files/map_MAA001665_B112513_P9_S369.%j.err
#SBATCH --time=24:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369
STAR --version
/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/Mmur_3.0_index_2.7.1a --readFilesIn /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/MAA001665_B112513_P9_S369/MAA001665_B112513_P9_S369_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369/1 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/Roozbeh/single_cell_project/Lemur_genome/Kransow_reference/ref_Mmur_3.0.gtf --outReadsUnmapped Fastx 

/oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.3a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 1000000 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-2.7.1a/Mmur_3.0_index_2.7.1a --readFilesIn /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/MAA001665_B112513_P9_S369/MAA001665_B112513_P9_S369_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369/2 --outSAMtype BAM Unsorted --chimSegmentMin 10 --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --scoreInsOpen -2 --scoreInsBase -2 --alignSJstitchMismatchNmax 0 -1 0 0 --chimSegmentReadGapMax 0 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/Roozbeh/single_cell_project/Lemur_genome/Kransow_reference/ref_Mmur_3.0.gtf --outReadsUnmapped Fastx 


date
