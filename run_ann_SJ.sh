#!/bin/bash
#
#SBATCH --job-name=ann_SJ_180819_11
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Slide_Puck_180819_11_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/180819_11/log_files/ann_SJ_180819_11.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Slide_Puck_180819_11_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/180819_11/log_files/ann_SJ_180819_11.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence,owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:62091598:62091600
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Slide_Puck_180819_11_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/180819_11/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --single 
date
