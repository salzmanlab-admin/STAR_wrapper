#!/bin/bash
#
#SBATCH --job-name=class_input_TSP2_Skin_chest_SS2_B113708_B111653_Stromal_P17_S377
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Skin_chest_SS2_B113708_B111653_Stromal_P17_S377/log_files/class_input_TSP2_Skin_chest_SS2_B113708_B111653_Stromal_P17_S377.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Skin_chest_SS2_B113708_B111653_Stromal_P17_S377/log_files/class_input_TSP2_Skin_chest_SS2_B113708_B111653_Stromal_P17_S377.%j.err
#SBATCH --time=48:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=150Gb
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Skin_chest_SS2_B113708_B111653_Stromal_P17_S377/ --gtf /oak/stanford/groups/horence/circularRNApipeline_Cluster/index/grch38_known_genes.gtf --annotator /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38.pkl --bams /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/TSP2_SS2_RUN1/TSP2_Skin_chest_SS2_B113708_B111653_Stromal_P17_S377/2Aligned.out.bam 
date
