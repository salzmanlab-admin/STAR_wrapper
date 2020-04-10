#!/bin/bash
#
#SBATCH --job-name=fusion_P9_PB_plate_4_S369
#SBATCH --output=/oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/180605_NB501961_0118_AHTLKLBGX5_Final/fastqs/salzman_lab_output_files/HLCA_smartseq_0118_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_PB_plate_4_S369/log_files/fusion_P9_PB_plate_4_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/180605_NB501961_0118_AHTLKLBGX5_Final/fastqs/salzman_lab_output_files/HLCA_smartseq_0118_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_PB_plate_4_S369/log_files/fusion_P9_PB_plate_4_S369.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
/scg/apps/software/star-fusion/1.8.1/STAR-Fusion --genome_lib_dir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-Fusion/GRCh38_gencode_v31_CTAT_lib_Oct012019.plug-n-play/ctat_genome_lib_build_dir/ -J  /oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/180605_NB501961_0118_AHTLKLBGX5_Final/fastqs/salzman_lab_output_files/HLCA_smartseq_0118_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_PB_plate_4_S369/1Chimeric.out.junction --output_dir /oak/stanford/groups/krasnow/ktrav/HLCA/datass2/sequencing_runs/180605_NB501961_0118_AHTLKLBGX5_Final/fastqs/salzman_lab_output_files/HLCA_smartseq_0118_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/P9_PB_plate_4_S369/star_fusion 
date
