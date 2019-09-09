#!/bin/bash
#
#SBATCH --job-name=log_
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0//log_files/log_.%j.err
#SBATCH --time=5:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=500
#SBATCH --dependency=afterany:49931829:49931830:49931831:49931832:49931833:49931834:49931835:49931836:49931838:49931839:49931840:49931841
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_log.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0// -j GLM_SRR027963.49931833 GLM_SRR078586.49931840 class_input_SRR027963.49931829 class_input_SRR078586.49931835 compare_SRR027963.49931832 compare_SRR078586.49931839 ensembl_SRR027963.49931831 ensembl_SRR078586.49931838 log_SRR027963.49931834 log_SRR078586.49931841 modify_class_SRR027963.49931830 modify_class_SRR078586.49931836
date
