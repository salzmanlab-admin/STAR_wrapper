#!/bin/bash
#
#SBATCH --job-name=class_input_sim2_reads
#SBATCH --output=output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/log_files/class_input_sim2_reads.%j.out
#SBATCH --error=output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/log_files/class_input_sim2_reads.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
python3 scripts/create_class_input.py -i output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/sim2_reads/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
