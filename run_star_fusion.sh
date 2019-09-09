#!/bin/bash
#
#SBATCH --job-name=fusion_reads_mismatch_20M
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/fusion_reads_mismatch_20M.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/log_files/fusion_reads_mismatch_20M.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:49735661
#SBATCH --kill-on-invalid-dep=yes
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J  /scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/1Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/HISAT_sim_data_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/reads_mismatch_20M/star_fusion 
date
