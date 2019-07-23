#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=job_output/log_.%j.out
#SBATCH --error=job_output/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:46555789:46555790:46555791:46555792:46555793:46555794:46555796:46555797:46555798:46555799:46555800:46555801
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j compare_TSP1_muscle_1_S19_L001_R2.46555790 compare_TSP1_muscle_1_S19_L002_R2.46555793 compare_TSP1_muscle_1_S19_L003_R2.46555797 compare_TSP1_muscle_1_S19_L004_R2.46555800 ensembl_TSP1_muscle_1_S19_L001_R2.46555789 ensembl_TSP1_muscle_1_S19_L002_R2.46555792 ensembl_TSP1_muscle_1_S19_L003_R2.46555796 ensembl_TSP1_muscle_1_S19_L004_R2.46555799 log_TSP1_muscle_1_S19_L001_R2.46555791 log_TSP1_muscle_1_S19_L002_R2.46555794 log_TSP1_muscle_1_S19_L003_R2.46555798 log_TSP1_muscle_1_S19_L004_R2.46555801
date
