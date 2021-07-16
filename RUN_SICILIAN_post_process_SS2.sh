#!/bin/bash
## this is a wrapper for passing the input arguments to the SICILIAN postprocessing script


############ Input arguments ###########################
OUT_DIR="/oak/stanford/groups/horence/Roozbeh/single_cell_project/output"   #SICILIAN output folders for  all samples in a dataset should be in ${OUT_DIR}/${RUN_NAME}#
RUN_NAME="test"
GTF_FILE="/oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf"
EXON_PICKLE_FILE="/oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq_exon_bounds.pkl"
SPLICE_PICKLE_FILE="/oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq_splices.pkl"
DATA_FORMAT="ss2"  # scRNA-Seq data format, should be either 10x or SS2
QUEUE="owners,quake"   # the queue for submitting jobs
########################################################

######## the three steps required for SICILIAN postprocessing #########
## For running each step, its corresponding flag should be set to True, otherwise it should be set to False
RUN_consolidate="True"
RUN_process="False"
RUN_postprocess="True"
######################################################################


python3 SICILIAN_post_process.py -d ${OUT_DIR} -r ${RUN_NAME} -g ${GTF_FILE} -e ${EXON_PICKLE_FILE} -s ${SPLICE_PICKLE_FILE} -f ${DATA_FORMAT} -q ${QUEUE} -a ${RUN_consolidate} -b ${RUN_process} -c ${RUN_postprocess}

