#!/bin/bash
#
#SBATCH --job-name=ensembl_M12_B000388_B009054_S300
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/M12_B000388_B009054_S300/log_files/ensembl_M12_B000388_B009054_S300.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/M12_B000388_B009054_S300/log_files/ensembl_M12_B000388_B009054_S300.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:14325998:14325999:14326000:14326001:14326002
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/add_ensembl_id.R /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/M12_B000388_B009054_S300/ Mmur_3.0  0 
date
