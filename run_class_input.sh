#!/bin/bash
#
#SBATCH --job-name=class_input_MAA001675_B109003_P9_S369
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/log_files/class_input_MAA001675_B109003_P9_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/log_files/class_input_MAA001675_B109003_P9_S369.%j.err
#SBATCH --time=48:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=150Gb
#SBATCH --dependency=afterok:15124492:15124493:15124494
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/ --assembly Mmur_3.0 --bams /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/1Aligned.out.bam /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/2Aligned.out.bam 
date
