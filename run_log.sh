#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:48372814:48372815:48372816:48372818
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_Engstrom_sim1_trimmed.48372816 compare_Engstrom_sim1_trimmed.48372815 ensembl_Engstrom_sim1_trimmed.48372814 log_Engstrom_sim1_trimmed.48372818
date
