#!/bin/bash
#
#SBATCH --job-name=class_input_SRR6782112
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/class_input_SRR6782112.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/log_files/class_input_SRR6782112.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
#SBATCH --dependency=afterok:55462617:55462618:55462619:55462620:55462621
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_class_input.py -i /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/SC_benchmarking_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6782112/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --single --tenX
date
