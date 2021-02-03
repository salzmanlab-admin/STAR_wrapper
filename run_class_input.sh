#!/bin/bash
#
#SBATCH --job-name=class_input_R_SCV648_4
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/class_input_R_SCV648_4.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/log_files/class_input_R_SCV648_4.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=200Gb
#SBATCH --dependency=afterok:15683297:15683299:15683301
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/ --gtf /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --annotator /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq.pkl --bams /scratch/PI/horence/Roozbeh/single_cell_project/output/Minor_intron_colab/R_SCV648_4/2Aligned.out.bam --UMI_bar --stranded_library 
date
