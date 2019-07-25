#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=job_output/log_.%j.out
#SBATCH --error=job_output/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:46845426:46845429:46845430:46845432:46845434:46845437:46845438
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10// -j ann_SJ_B107809_A15_S135.46845430 class_input_B107809_A15_S135.46845432 compare_B107809_A15_S135.46845437 ensembl_B107809_A15_S135.46845434 log_B107809_A15_S135.46845438 map_B107809_A15_S135.46845426 star_fusion_B107809_A15_S135.46845429
date
