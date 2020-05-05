#!/bin/bash
#
#SBATCH --job-name=GLM_B107810_F3_S250
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_hg38_covid19_ercc_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107810_F3_S250/log_files/GLM_B107810_F3_S250.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_hg38_covid19_ercc_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107810_F3_S250/log_files/GLM_B107810_F3_S250.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=150Gb
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_hg38_covid19_ercc_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107810_F3_S250/ hg38_covid19_ercc  0 
date
