#!/bin/bash
#
#SBATCH --job-name=modify_B107826_F16_S195
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107826_F16_S195/log_files/modify_B107826_F16_S195.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107826_F16_S195/log_files/modify_B107826_F16_S195.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:50094757:50094758:50094759:50094760
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/modify_junction_ids.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/B107826_F16_S195/ 
date
