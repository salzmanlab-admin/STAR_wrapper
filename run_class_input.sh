#!/bin/bash
#
#SBATCH --job-name=class_input_TSP1_endopancreas_2_S8_L004_R2
#SBATCH --output=job_output/class_input_TSP1_endopancreas_2_S8_L004_R2.%j.out
#SBATCH --error=job_output/class_input_TSP1_endopancreas_2_S8_L004_R2.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
#SBATCH --dependency=afterok:46089690
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_demultiplexed_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_endopancreas_2_S8_L004_R2/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --single
date
