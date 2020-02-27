#!/bin/bash
#
#SBATCH --job-name=class_input_N18_B002587_S102
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/log_files/class_input_N18_B002587_S102.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/log_files/class_input_N18_B002587_S102.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
#SBATCH --dependency=afterok:62098416:62098417:62098418
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/ --assembly hg38 --bams /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/1Aligned.out.bam /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N18_B002587_S102/2Aligned.out.bam 
date
