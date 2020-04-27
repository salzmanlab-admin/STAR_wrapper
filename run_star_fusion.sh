#!/bin/bash
#
#SBATCH --job-name=fusion_MAA001675_B109003_P9_S369
#SBATCH --output=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/log_files/fusion_MAA001675_B109003_P9_S369.%j.out
#SBATCH --error=/oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/log_files/fusion_MAA001675_B109003_P9_S369.%j.err
#SBATCH --time=12:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:15124492
#SBATCH --kill-on-invalid-dep=yes
date
/scg/apps/software/star-fusion/1.8.1/STAR-Fusion --genome_lib_dir  /oak/stanford/groups/horence/Roozbeh/single_cell_project/STAR-Fusion/GRCh38_gencode_v31_CTAT_lib_Oct012019.plug-n-play/ctat_genome_lib_build_dir/ -J  /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/1Chimeric.out.junction --output_dir /oak/stanford/groups/krasnow/MLCA/dataSS2/Antoine_SS2/rawdata/token_A00111_0357/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/MAA001675_B109003_P9_S369/star_fusion 
date
