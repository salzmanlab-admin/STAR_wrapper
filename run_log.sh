#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:52337982:52337983:52337984:52337985
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_CMLUConn_SRR3192410_trimmed.52337984 compare_CMLUConn_SRR3192410_trimmed.52337983 ensembl_CMLUConn_SRR3192410_trimmed.52337982 log_CMLUConn_SRR3192410_trimmed.52337985
date
