#!/bin/bash
#
#SBATCH --job-name=ann_SJ_MAA001675_B109003_P9_S369
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/log_files/ann_SJ_MAA001675_B109003_P9_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/log_files/ann_SJ_MAA001675_B109003_P9_S369.%j.err
#SBATCH --time=24:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:15124492:15124493
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/ -a Mmur_3.0 -g /oak/stanford/groups/horence/Roozbeh/single_cell_project/Lemur_genome/Kransow_reference/ref_Mmur_3.0.gtf 
date
