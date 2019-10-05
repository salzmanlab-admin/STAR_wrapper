#!/bin/bash
#
#SBATCH --job-name=GLM_B107924_I6_S234
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107924_I6_S234/log_files/GLM_B107924_I6_S234.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107924_I6_S234/log_files/GLM_B107924_I6_S234.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=70Gb
date
Rscript scripts/GLM_script.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107924_I6_S234/  0 
date
