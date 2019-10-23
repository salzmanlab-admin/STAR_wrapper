#!/bin/sh
#############################
# File Name :run_STAR_wrapper_across_samples.sh
#
# Purpose : This wrapper calls the write.job.py script for many samples given by an input file
#
# Creation Date : 06-06-2019
#
# Last Modified : Thu 17 Oct 2019 01:16:57 PM PDT
#
# Created By : Roozbeh Dehghannasiri
#
##############################

INFILE=$1

for sample in $(cat ${INFILE})
do
 echo "$sample"
 python3 /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/write_jobs_smartseq_scg.py -s ${sample}
done
