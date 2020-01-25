#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:14052727:14052730:14052732:14052734:14052736:14052737:14052739:14052741
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0133_BH3VGJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_P9_B001493_B007957_S369.14052741 ann_SJ_P9_B001493_B007957_S369.14052732 class_input_P9_B001493_B007957_S369.14052734 compare_P9_B001493_B007957_S369.14052739 ensembl_P9_B001493_B007957_S369.14052737 fusion_P9_B001493_B007957_S369.14052730 map_P9_B001493_B007957_S369.14052727 modify_class_P9_B001493_B007957_S369.14052736
date
