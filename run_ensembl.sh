#!/bin/bash
#
#SBATCH --job-name=ensembl_P9_B001493_B007957_S369
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B001493_B007957_S369/log_files/ensembl_P9_B001493_B007957_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B001493_B007957_S369/log_files/ensembl_P9_B001493_B007957_S369.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:14052727:14052730:14052732:14052734:14052736
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/add_ensembl_id.R /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B001493_B007957_S369/ Mmur_3.0  0 
date
