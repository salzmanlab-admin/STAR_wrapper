#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:51903606:51903607:51903609:51903611:51903613:51903615:51903616:51903618:51903619
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_B107821_K14_S240.51903618 ann_SJ_B107821_K14_S240.51903609 class_input_B107821_K14_S240.51903611 compare_B107821_K14_S240.51903616 ensembl_B107821_K14_S240.51903615 fusion_B107821_K14_S240.51903607 log_B107821_K14_S240.51903619 map_B107821_K14_S240.51903606 modify_class_B107821_K14_S240.51903613
date
