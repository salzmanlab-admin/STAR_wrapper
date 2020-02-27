#!/bin/bash
#
#SBATCH --job-name=ann_SJ_N18_B002591_S270
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002591_S270/log_files/ann_SJ_N18_B002591_S270.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002591_S270/log_files/ann_SJ_N18_B002591_S270.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:62098421:62098422
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002591_S270/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
