#!/bin/sh
#############################
# File Name :run_STAR_wrapper_across_samples.sh
#
# Purpose : This wrapper calls the write.job.py script for many samples given by an input file
#
# Creation Date : 06-06-2019
#
# Last Modified : Tue 23 Jul 2019 01:59:36 PM PDT
#
# Created By : Roozbeh Dehghannasiri
#
##############################

INFILE=$1

for sample in $(cat ${INFILE})
do
 echo "$sample"
 python3 write_jobs_smartseq.py -s ${sample}
done
