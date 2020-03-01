#!/bin/bash
#
#SBATCH --job-name=ann_SJ_B19_B001231_S43
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B19_B001231_S43/log_files/ann_SJ_B19_B001231_S43.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B19_B001231_S43/log_files/ann_SJ_B19_B001231_S43.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:62330840:62330841
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B19_B001231_S43/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
