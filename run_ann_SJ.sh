#!/bin/bash
#
#SBATCH --job-name=ann_SJ_SRR6546284
#SBATCH --output=job_output/ann_SJ_SRR6546284.%j.out
#SBATCH --error=job_output/ann_SJ_SRR6546284.%j.err
#SBATCH --time=5:00:00
#SBATCH --qos=normal
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=5Gb
#SBATCH --dependency=afterok:45126175
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_1_cSRGM_3/SRR6546284/ -a mm10 -g /share/PI/horence/circularRNApipeline_Cluster/index/mm10_genes.gtf 
date
