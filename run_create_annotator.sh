#!/bin/bash
#
#SBATCH --job-name=create_annotator
#SBATCH --output=job_output/create_annotator.%j.out
#SBATCH --error=job_output/create_annotator.%j.err
#SBATCH --time=1:00:00
#SBATCH --account=horence
#SBATCH --partition=horence,owners
#SBATCH --nodes=1
#SBATCH --mem=10Gb
##SBATCH --dependency=afterok:13005642:13005643:13005644:13005645
##SBATCH --kill-on-invalid-dep=yes

ASSEMBLY="hg38_RefSeq"
GTF="/oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/GRCh38_latest_genomic.gff"
date
a="python3 /scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/scripts/create_annotator.py --assembly ${ASSEMBLY} --gtf_path ${GTF}"
eval $a
date
