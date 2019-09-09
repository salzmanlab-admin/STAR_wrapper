#!/bin/bash
#
#SBATCH --job-name=ann_SJ_reads_mismatch_20M
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/ann_SJ_reads_mismatch_20M.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/ann_SJ_reads_mismatch_20M.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:49735661:49735664
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/ -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf 
date
