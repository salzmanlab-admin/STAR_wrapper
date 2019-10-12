#!/bin/bash
#
#SBATCH --job-name=log_B107817_K8_S6
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107817_K8_S6/log_files/log_B107817_K8_S6.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107817_K8_S6/log_files/log_B107817_K8_S6.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:52568323:52568351:52568352:52568353:52568354
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107817_K8_S6/ -j class_input_B107817_K8_S6.52568323 modify_class_B107817_K8_S6.52568351 ensembl_B107817_K8_S6.52568352 compare_B107817_K8_S6.52568353 GLM_B107817_K8_S6.52568354
date
