#!/bin/bash
#
#SBATCH --job-name=class_input_SRR078586
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/log_files/class_input_SRR078586.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/log_files/class_input_SRR078586.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/DNA_Seq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR078586/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --single
date
