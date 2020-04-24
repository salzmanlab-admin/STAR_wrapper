#!/bin/bash
#
#SBATCH --job-name=class_input_TSP1_exopancreas1_1_S19_L004
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_exopancreas1_1_S19_L004/log_files/class_input_TSP1_exopancreas1_1_S19_L004.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_exopancreas1_1_S19_L004/log_files/class_input_TSP1_exopancreas1_1_S19_L004.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_exopancreas1_1_S19_L004/ --assembly hg38 --bams /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_redo_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_exopancreas1_1_S19_L004/2Aligned.out.bam --UMI_bar 
date
