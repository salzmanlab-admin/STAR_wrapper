#!/bin/bash
#
#SBATCH --job-name=modify_P9_B001493_B007957_S369
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B001493_B007957_S369/log_files/modify_P9_B001493_B007957_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B001493_B007957_S369/log_files/modify_P9_B001493_B007957_S369.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:14081557:14081558:14081559:14081560
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/modify_junction_ids.R /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B001493_B007957_S369/ Mmur_3.0 
date
