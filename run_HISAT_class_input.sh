#!/bin/bash
#
#SBATCH --job-name=HISAT_class_input_SRR9644810
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/log_files/HISAT_class_input_SRR9644810.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/log_files/HISAT_class_input_SRR9644810.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=100Gb
#SBATCH --dependency=afterok:53869198:53869199
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/1000_Genome_HISAT_k_7_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR9644810/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --single 
date
