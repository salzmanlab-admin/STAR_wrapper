#!/bin/bash
#
#SBATCH --job-name=class_input_CMLUConn_SRR3192410_trimmed
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/class_input_CMLUConn_SRR3192410_trimmed.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/log_files/class_input_CMLUConn_SRR3192410_trimmed.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/CML_2410_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/CMLUConn_SRR3192410_trimmed/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
