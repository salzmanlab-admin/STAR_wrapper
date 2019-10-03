#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:51834214:51834215:51834216:51834217:51834218:51834219:51834220:51834221:51834222:51834223:51834224:51834225
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_sim1_reads.51834218 GLM_sim2_reads.51834224 class_input_sim1_reads.51834214 class_input_sim2_reads.51834220 compare_sim1_reads.51834217 compare_sim2_reads.51834223 ensembl_sim1_reads.51834216 ensembl_sim2_reads.51834222 log_sim1_reads.51834219 log_sim2_reads.51834225 modify_class_sim1_reads.51834215 modify_class_sim2_reads.51834221
date
