#!/bin/bash
#
#SBATCH --job-name=ann_SJ_TSP1_bladder_2_S14_L004
#SBATCH --output=job_output/ann_SJ_TSP1_bladder_2_S14_L004.%j.out
#SBATCH --error=job_output/ann_SJ_TSP1_bladder_2_S14_L004.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:48073472:48073473
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_bladder_2_S14_L004/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --single 
date
