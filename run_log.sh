#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=job_output/log_.%j.out
#SBATCH --error=job_output/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:46150854:46150856
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j ensembl_B107809_N5_S272.46150854 log_B107809_N5_S272.46150856
date
