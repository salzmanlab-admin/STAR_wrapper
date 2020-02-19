#!/bin/bash
#
#SBATCH --job-name=P1_6_S2_L001_CI
#SBATCH --output=/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/job_output/P1_6_S2_L001_CI.%j.out
#SBATCH --error=/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/job_output/P1_6_S2_L001_CI.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=300Gb
date
python3 /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/scripts/light_class_input.py --fastqs /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_171205_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P1_6_S2_L001/2Aligned.out.bam --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_171205_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P1_6_S2_L001/ --assembly hg38
date
