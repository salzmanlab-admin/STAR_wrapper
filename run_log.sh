#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=job_output/log_.%j.out
#SBATCH --error=job_output/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:47840167:47840168:47840169:47840170:47840171:47840172:47840173
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0// -j ann_SJ_Engstrom_sim1_trimmed.47840169 class_input_Engstrom_sim1_trimmed.47840170 compare_Engstrom_sim1_trimmed.47840172 ensembl_Engstrom_sim1_trimmed.47840171 log_Engstrom_sim1_trimmed.47840173 map_Engstrom_sim1_trimmed.47840167 star_fusion_Engstrom_sim1_trimmed.47840168
date
