#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=job_output/log_.%j.out
#SBATCH --error=job_output/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:48247600:48247601
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_Engstrom_sim1_trimmed.48247600 log_Engstrom_sim1_trimmed.48247601
date
