#!/bin/bash
#
#SBATCH --job-name=class_input_SRR7311317
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/mouse_brain_PNAS_Tasic_2018/SRR7311317/log_files/class_input_SRR7311317.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/mouse_brain_PNAS_Tasic_2018/SRR7311317/log_files/class_input_SRR7311317.%j.err
#SBATCH --time=48:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=200Gb
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/mouse_brain_PNAS_Tasic_2018/SRR7311317/ --gtf /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/mouse/refseq_GRCm38.p6/GCF_000001635.26_GRCm38.p6_genomic.gtf --annotator /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/mouse/refseq_GRCm38.p6/refseq_mm10.p6.pkl --bams /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/mouse_brain_PNAS_Tasic_2018/SRR7311317/1Aligned.out.bam /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/mouse_brain_PNAS_Tasic_2018/SRR7311317/2Aligned.out.bam --stranded_library --paired 
date
