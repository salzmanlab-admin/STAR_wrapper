#!/bin/sh
#############################
# File Name : STAR_wrapper.sh
#
# Purpose : This script calls STAR aligner
#
# Creation Date : 02-06-2019
#
# Last Modified : Mon 17 Jun 2019 06:03:53 PM PDT
#
# Created By : Roozbeh Dehghannasiri
#
##############################

INFILE=$1                 #contains the list of SRR IDs for the fastq files to be aligned by STAR 
OUT_FOLDER=$2             #the folder in OUT_DIR in which all STAR ouput files will be written

mm10_gen_dir="/scratch/PI/horence/JuliaO/single_cell/STAR_output/mm10_index_2.7.1a"    # the path to the folder with genome index files
FASTQ_DIR="/scratch/PI/horence/Roozbeh/single_cell_project/data/Tabula_Muris"          # the path to the folder containing input fastq files
OUT_DIR="/scratch/PI/horence/Roozbeh/single_cell_project/data/Tabula_Muris"            # where OUT_FOLDER will be created 


mkdir ${OUT_DIR}/${OUT_FOLDER}

# calling STAR for R1
for FASTQ_ID in $(cat ${INFILE})
do
    /scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21 --genomeDir ${mm10_gen_dir} --readFilesIn ${FASTQ_DIR}/${FASTQ_ID}_1_val_1.fq.gz  --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix ${OUT_DIR}/${OUT_FOLDER}/${FASTQ_ID}_1 --outSAMtype SAM --chimSegmentMin 12 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 13 --alignSJstitchMismatchNmax 5 -1 5 5 --chimSegmentReadGapMax 3 --alignSJDBoverhangMin 13 --outReadsUnmapped Fastx
done

# calling STAR for R2
for FASTQ_ID in $(cat ${INFILE})
do
    /scratch/PI/horence/Roozbeh/STAR-2.7.1a/bin/Linux_x86_64/STAR --runThreadN 4 --alignIntronMax 21  --genomeDir ${mm10_gen_dir} --readFilesIn ${FASTQ_DIR}/${FASTQ_ID}_2_val_2.fq.gz  --readFilesCommand zcat --twopassMode Basic --outFileNamePrefix ${OUT_DIR}/${OUT_FOLDER}/${FASTQ_ID}_2 --outSAMtype SAM --chimSegmentMin 12 --outSAMattributes All --chimOutType Junctions SeparateSAMold --chimJunctionOverhangMin 13 --alignSJstitchMismatchNmax 5 -1 5 5 --chimSegmentReadGapMax 3 --alignSJDBoverhangMin 13 --outReadsUnmapped Fastx
done

