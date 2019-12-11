#!/bin/bash
#
#SBATCH --job-name=fusion_H10_B000376_B009051_S178
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0132_AH3VFJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/H10_B000376_B009051_S178/log_files/fusion_H10_B000376_B009051_S178.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0132_AH3VFJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/H10_B000376_B009051_S178/log_files/fusion_H10_B000376_B009051_S178.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:13063484
#SBATCH --kill-on-invalid-dep=yes
date
/scg/apps/software/star-fusion/1.8.1/STAR-Fusion --genome_lib_dir /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-Fusion/GRCh38_gencode_v31_CTAT_lib_Oct012019.plug-n-play/ctat_genome_lib_build_dir/ -J  /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0132_AH3VFJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/H10_B000376_B009051_S178/1Chimeric.out.junction --output_dir /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0132_AH3VFJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/H10_B000376_B009051_S178/star_fusion 
date
