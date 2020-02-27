#!/bin/bash
#
#SBATCH --job-name=class_input_N22_B001229_S142
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001229_S142/log_files/class_input_N22_B001229_S142.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001229_S142/log_files/class_input_N22_B001229_S142.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
#SBATCH --dependency=afterok:62099233:62099234:62099235
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001229_S142/ --assembly hg38 --bams /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001229_S142/1Aligned.out.bam /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0106_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/N22_B001229_S142/2Aligned.out.bam 
date
