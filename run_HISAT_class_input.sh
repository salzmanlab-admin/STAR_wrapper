#!/bin/bash
#
#SBATCH --job-name=CI_HISAT
#SBATCH --output=job_output/CI_HISAT.%j.out
#SBATCH --error=job_output/CI_HISAT.%j.err
#SBATCH --time=24:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=60Gb
##SBATCH --dependency=afterok:51903606:51903607:51903609
##SBATCH --kill-on-invalid-dep=yes
date
python3 -u scripts/create_class_input.py -i /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/output/HISAT_ -I /oak/stanford/groups/horence/Roozbeh/single_cell_project/HISAT2/SRR9134109_HISAT.bam -a hg38 -g /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --single
date
