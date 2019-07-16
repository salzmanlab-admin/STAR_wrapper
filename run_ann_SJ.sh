#!/bin/bash
#
#SBATCH --job-name=ann_SJ_TSP1_muscle_1_S19_L004_R2
#SBATCH --output=job_output/ann_SJ_TSP1_muscle_1_S19_L004_R2.%j.out
#SBATCH --error=job_output/ann_SJ_TSP1_muscle_1_S19_L004_R2.%j.err
#SBATCH --time=24:00:00
#SBATCH --qos=normal
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=50Gb
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_demultiplexed_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_muscle_1_S19_L004_R2/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf --single 
date
