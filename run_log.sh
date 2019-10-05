#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:52046279:52046280:52046281:52046282:52046283:52046284:52046285:52046286:52046287:52046288:52046289:52046290
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_TSP1_muscle_3_S21_L001.52046280 GLM_TSP1_muscle_3_S21_L002.52046283 GLM_TSP1_muscle_3_S21_L003.52046286 GLM_TSP1_muscle_3_S21_L004.52046289 compare_TSP1_muscle_3_S21_L001.52046279 compare_TSP1_muscle_3_S21_L002.52046282 compare_TSP1_muscle_3_S21_L003.52046285 compare_TSP1_muscle_3_S21_L004.52046288 log_TSP1_muscle_3_S21_L001.52046281 log_TSP1_muscle_3_S21_L002.52046284 log_TSP1_muscle_3_S21_L003.52046287 log_TSP1_muscle_3_S21_L004.52046290
date
