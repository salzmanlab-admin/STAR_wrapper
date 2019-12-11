#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_IntronMax_1000000_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_IntronMax_1000000_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p quake
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:56263464:56263465:56263466:56263467:56263468
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_IntronMax_1000000_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_TxDx2016-001-001_S1_L001.56263467 compare_TxDx2016-001-001_S1_L001.56263466 ensembl_TxDx2016-001-001_S1_L001.56263465 log_TxDx2016-001-001_S1_L001.56263468 modify_class_TxDx2016-001-001_S1_L001.56263464
date
