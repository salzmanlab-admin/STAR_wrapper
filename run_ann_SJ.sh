#!/bin/bash
#
#SBATCH --job-name=ann_SJ_B107821_K14_S240
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107821_K14_S240/log_files/ann_SJ_B107821_K14_S240.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107821_K14_S240/log_files/ann_SJ_B107821_K14_S240.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:51903606:51903607
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107821_K14_S240/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
