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
#SBATCH --dependency=afterany:13005642:13005643:13005644:13005645:13005646:13005647:13005648:13005649:13005650
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_B107811_P4_S249.13005649 ann_SJ_B107811_P4_S249.13005644 class_input_B107811_P4_S249.13005645 compare_B107811_P4_S249.13005648 ensembl_B107811_P4_S249.13005647 fusion_B107811_P4_S249.13005643 log_B107811_P4_S249.13005650 map_B107811_P4_S249.13005642 modify_class_B107811_P4_S249.13005646
date
