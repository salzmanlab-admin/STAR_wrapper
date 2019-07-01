#!/bin/bash
#
#SBATCH --job-name=class_input_SRR6546284
#SBATCH --output=job_output/class_input_SRR6546284.%j.out
#SBATCH --error=job_output/class_input_SRR6546284.%j.err
#SBATCH --time=10:00
#SBATCH --qos=normal
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=1Gb
#SBATCH --dependency=afterok:45126176
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_1_cSRGM_3/SRR6546284/ -a mm10 -g /share/PI/horence/circularRNApipeline_Cluster/index/mm10_genes.gtf
date
