#!/bin/sh
#############################
# File Name :run_STAR_wrapper_across_samples.sh
#
# Purpose : This wrapper calls the write_jobs_lemur_smartseq.py script for many samples given by an input file
#
# Creation Date : 06-06-2019
#
# Last Modified : Sun 15 Dec 2019 11:50:44 PM PST
#
# Created By : Roozbeh Dehghannasiri
#
##############################

INFILE=$1

for sample in $(cat ${INFILE})
do
 echo "$sample"
 python3 write_jobs_HLCA_10x.py -s ${sample}
done
