#!/bin/bash
#
#SBATCH --job-name=ann_SJ_B107809_A15_S135
#SBATCH --output=job_output/ann_SJ_B107809_A15_S135.%j.out
#SBATCH --error=job_output/ann_SJ_B107809_A15_S135.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:46845426:46845429
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10/B107809_A15_S135/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf 
date
