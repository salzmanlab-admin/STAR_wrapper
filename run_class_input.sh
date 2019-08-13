#!/bin/bash
#
#SBATCH --job-name=class_input_B107809_N5_S124
#SBATCH --output=job_output/class_input_B107809_N5_S124.%j.out
#SBATCH --error=job_output/class_input_B107809_N5_S124.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107809_N5_S124/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf 
date
