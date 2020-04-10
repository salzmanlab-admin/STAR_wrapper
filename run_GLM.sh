#!/bin/bash
#
#SBATCH --job-name=GLM_MAA001665_B112513_P9_S369
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369/log_files/GLM_MAA001665_B112513_P9_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369/log_files/GLM_MAA001665_B112513_P9_S369.%j.err
#SBATCH --time=48:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=150Gb
#SBATCH --dependency=afterok:14785552:14785553:14785554
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0356/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001665_B112513_P9_S369/ Mmur_3.0  0 
date
