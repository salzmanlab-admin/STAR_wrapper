#!/bin/bash
#
#SBATCH --job-name=GLM_G28616.NCI-H2228
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/log_files/GLM_G28616.NCI-H2228.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/log_files/GLM_G28616.NCI-H2228.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=200Gb
#SBATCH --dependency=afterok:62766503
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/ hg38  0 
date
