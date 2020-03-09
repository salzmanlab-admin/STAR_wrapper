#!/bin/bash
#
#SBATCH --job-name=fusion_P9_B002593_S9
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/log_files/fusion_P9_B002593_S9.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/log_files/fusion_P9_B002593_S9.%j.err
#SBATCH --time=12:00:00
#SBATCH -p quake,horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:62663385
#SBATCH --kill-on-invalid-dep=yes
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J  /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/1Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/HLCA_smartseq_0108_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_B002593_S9/star_fusion 
date
