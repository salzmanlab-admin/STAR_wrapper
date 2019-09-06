#!/bin/bash
#
#SBATCH --job-name=ann_SJ_ sim5_reads
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/ sim5_reads/log_files/ann_SJ_ sim5_reads.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/ sim5_reads/log_files/ann_SJ_ sim5_reads.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=40Gb
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/sim_101_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/ sim5_reads/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
