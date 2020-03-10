#!/bin/bash
#
#SBATCH --job-name=class_input_MLCA_ANTOINE_TRACHEA_S2_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_ANTOINE_TRACHEA_S2_L002/log_files/class_input_MLCA_ANTOINE_TRACHEA_S2_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_ANTOINE_TRACHEA_S2_L002/log_files/class_input_MLCA_ANTOINE_TRACHEA_S2_L002.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=150Gb
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_ANTOINE_TRACHEA_S2_L002/ --assembly Mmur_3.0 --bams /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MLCA_ANTOINE_TRACHEA_S2_L002/2Aligned.out.bam --UMI_bar 
date
