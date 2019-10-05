#!/bin/bash
#
#SBATCH --job-name=fusion_TxDx2016-001-001_S1_L002
#SBATCH --output=output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/fusion_TxDx2016-001-001_S1_L002.%j.out
#SBATCH --error=output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/log_files/fusion_TxDx2016-001-001_S1_L002.%j.err
#SBATCH --time=12:00:00
#SBATCH -p owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:52051764
#SBATCH --kill-on-invalid-dep=yes
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J  output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/1Chimeric.out.junction --output_dir output/circRNA_thirdparty_benchmarking_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TxDx2016-001-001_S1_L002/star_fusion 
date
