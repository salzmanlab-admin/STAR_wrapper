#!/bin/bash
#
#SBATCH --job-name=fusion_sim5_reads
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/STAR_sim/sim5_reads/log_files/fusion_sim5_reads.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/STAR_sim/sim5_reads/log_files/fusion_sim5_reads.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners,quake,normal
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:26958706
#SBATCH --kill-on-invalid-dep=yes
date
/scg/apps/software/star-fusion/1.8.1/STAR-Fusion --genome_lib_dir  /oak/stanford/groups/horence/Roozbeh/software/STAR-Fusion.v1.9.0/GRCh38_gencode_v33_CTAT_lib_Apr062020.plug-n-play/ctat_genome_lib_build_dir/ -J  /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/STAR_sim/sim5_reads/1Chimeric.out.junction --output_dir /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/STAR_sim/sim5_reads/star_fusion 
date
