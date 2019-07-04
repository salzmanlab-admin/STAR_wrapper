#!/bin/bash
#
#SBATCH --job-name=class_input_SRR6546273
#SBATCH --output=job_output/class_input_SRR6546273.%j.out
#SBATCH --error=job_output/class_input_SRR6546273.%j.err
#SBATCH --time=5:00
#SBATCH --qos=normal
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=1Gb
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6546273/ -a mm10 -g /share/PI/horence/circularRNApipeline_Cluster/index/mm10_genes.gtf 
date
