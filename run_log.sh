#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=job_output/log_.%j.out
#SBATCH --error=job_output/log_.%j.err
#SBATCH --time=5:00
#SBATCH --qos=normal
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:45445816:45445817
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j class_input_SRR6546273.45445816 log_SRR6546273.45445817
date
