#!/bin/bash
#
#SBATCH --job-name=fusion_10X_P4_0_S1_L001
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Tabula_muris_senis/10X_P4_0_S1_L001/log_files/fusion_10X_P4_0_S1_L001.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Tabula_muris_senis/10X_P4_0_S1_L001/log_files/fusion_10X_P4_0_S1_L001.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners,quake
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:8435354:8435356
#SBATCH --kill-on-invalid-dep=yes
date
/oak/stanford/groups/horence/Roozbeh/software/STAR-Fusion.v1.9.0/STAR-Fusion --genome_lib_dir  /oak/stanford/groups/horence/Roozbeh/software/STAR-Fusion.v1.9.0/GRCh38_gencode_v33_CTAT_lib_Apr062020.plug-n-play/ctat_genome_lib_build_dir/ -J    /scratch/PI/horence/Roozbeh/single_cell_project/output/Tabula_muris_senis/10X_P4_0_S1_L001/2Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/Tabula_muris_senis/10X_P4_0_S1_L001/star_fusion 
date
