#!/bin/bash
#
#SBATCH --job-name=GLM_P9_B002593_S9
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/log_files/GLM_P9_B002593_S9.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/log_files/GLM_P9_B002593_S9.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=200Gb
#SBATCH --dependency=afterok:62663385:62663386:62663387:62663388
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/ hg38  0 
date
