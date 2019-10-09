#!/bin/bash
#
#SBATCH --job-name=ann_SJ_TxDx2016-001-001_S1_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/ann_SJ_TxDx2016-001-001_S1_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/ann_SJ_TxDx2016-001-001_S1_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:52137032:52137033
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
