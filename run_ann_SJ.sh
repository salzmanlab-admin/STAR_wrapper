#!/bin/bash
#
#SBATCH --job-name=ann_SJ_SRR7547691
#SBATCH --output=job_output/ann_SJ_SRR7547691.%j.out
#SBATCH --error=job_output/ann_SJ_SRR7547691.%j.err
#SBATCH --time=10:00
#SBATCH --qos=normal
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=5Gb
#SBATCH --dependency=afterok:45440295
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR7547691/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/hg38_genes.gtf --single 
date
