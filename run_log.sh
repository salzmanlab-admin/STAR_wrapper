#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:50094746:50094748:50094749:50094750:50094751:50094752:50094753:50094754:50094755
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_B107826_F15_S194.50094754 ann_SJ_B107826_F15_S194.50094749 class_input_B107826_F15_S194.50094750 compare_B107826_F15_S194.50094753 ensembl_B107826_F15_S194.50094752 fusion_B107826_F15_S194.50094748 log_B107826_F15_S194.50094755 map_B107826_F15_S194.50094746 modify_class_B107826_F15_S194.50094751
date
