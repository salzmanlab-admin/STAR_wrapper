#!/bin/bash
#
#SBATCH --job-name=GLM_sim2_reads
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/log_files/GLM_sim2_reads.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/log_files/GLM_sim2_reads.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=70Gb
date
Rscript scripts/GLM_script.R /scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/  0 
date
