#!/bin/bash
#
#SBATCH --job-name=ann_SJ_B107811_C4_S250
#SBATCH --output=job_output/ann_SJ_B107811_C4_S250.%j.out
#SBATCH --error=job_output/ann_SJ_B107811_C4_S250.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:46389261
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_C4_S250/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf 
date
