#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:12149859:12149860:12149861:12149862:12149863:12149864:12149865:12149866:12149867
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_B107819_B18_S41.12149866 ann_SJ_B107819_B18_S41.12149861 class_input_B107819_B18_S41.12149862 compare_B107819_B18_S41.12149865 ensembl_B107819_B18_S41.12149864 fusion_B107819_B18_S41.12149860 log_B107819_B18_S41.12149867 map_B107819_B18_S41.12149859 modify_class_B107819_B18_S41.12149863
date
