#!/bin/bash
#
#SBATCH --job-name=class_input_P9_B002593_S9
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/log_files/class_input_P9_B002593_S9.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/log_files/class_input_P9_B002593_S9.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
#SBATCH --dependency=afterok:62663385:62663386:62663387
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/ --assembly hg38 --bams /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/1Aligned.out.bam /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/2Aligned.out.bam 
date
