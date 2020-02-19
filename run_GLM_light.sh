#!/bin/bash
#
#SBATCH --job-name=P2_6_S6_L002_GLM
#SBATCH --output=/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/job_output/P2_6_S6_L002_GLM.%j.out
#SBATCH --error=/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/job_output/P2_6_S6_L002_GLM.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=300Gb
date
ml load R/3.6
Rscript /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_180607_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P2_6_S6_L002/  1 
date
