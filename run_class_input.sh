#!/bin/bash
#
#SBATCH --job-name=class_input_TSP1_blood_3_S24_L004
#SBATCH --output=job_output/class_input_TSP1_blood_3_S24_L004.%j.out
#SBATCH --error=job_output/class_input_TSP1_blood_3_S24_L004.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=80Gb
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_blood_3_S24_L004/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --single
date
