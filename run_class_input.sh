#!/bin/bash
#
#SBATCH --job-name=class_input_B107811_P4_S249
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/log_files/class_input_B107811_P4_S249.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/log_files/class_input_B107811_P4_S249.%j.err
#SBATCH --time=24:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:13005642:13005643:13005644
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_class_input.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107811_P4_S249/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
