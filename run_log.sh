#!/bin/bash
#
#SBATCH --job-name=log_P1_7_S7_L002
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_171205_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P1_7_S7_L002/log_files/log_P1_7_S7_L002.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_171205_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P1_7_S7_L002/log_files/log_P1_7_S7_L002.%j.err
#SBATCH --time=5:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:59552771
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/HLCA_171205_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P1_7_S7_L002/ -j GLM_P1_7_S7_L002.59552771
date
