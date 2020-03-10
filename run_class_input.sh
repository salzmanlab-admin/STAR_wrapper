#!/bin/bash
#
#SBATCH --job-name=class_input_G28616.NCI-H2228
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/log_files/class_input_G28616.NCI-H2228.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/log_files/class_input_G28616.NCI-H2228.%j.err
#SBATCH --time=48:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/ --assembly hg38 --bams /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/1Aligned.out.bam /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_CCLE_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/G28616.NCI-H2228/2Aligned.out.bam 
date
