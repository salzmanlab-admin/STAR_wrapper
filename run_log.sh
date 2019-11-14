#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:54676561:54676563:54676567:54676569:54676571:54676573:54676575:54676576:54676578
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_B107924_N14_S60.54676576 ann_SJ_B107924_N14_S60.54676567 class_input_B107924_N14_S60.54676569 compare_B107924_N14_S60.54676575 ensembl_B107924_N14_S60.54676573 fusion_B107924_N14_S60.54676563 log_B107924_N14_S60.54676578 map_B107924_N14_S60.54676561 modify_class_B107924_N14_S60.54676571
date
