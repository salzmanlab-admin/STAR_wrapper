#!/bin/bash
#
#SBATCH --job-name=ann_SJ_N22_B001234_S154
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154/log_files/ann_SJ_N22_B001234_S154.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154/log_files/ann_SJ_N22_B001234_S154.%j.err
#SBATCH --time=24:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:62099238:62099239
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001234_S154/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
