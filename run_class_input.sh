#!/bin/bash
#
#SBATCH --job-name=class_input_TxDx2016-001-001_S1_L002
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/class_input_TxDx2016-001-001_S1_L002.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/class_input_TxDx2016-001-001_S1_L002.%j.err
#SBATCH --time=24:00:00
#SBATCH -p bigmem
#SBATCH --nodes=1
#SBATCH --mem=200Gb
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
