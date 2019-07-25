#!/bin/bash
#
#SBATCH --job-name=fusion_B107809_A15_S135
#SBATCH --output=job_output/fusion_B107809_A15_S135.%j.out
#SBATCH --error=job_output/fusion_B107809_A15_S135.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:46845426
#SBATCH --kill-on-invalid-dep=yes
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J  output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10/B107809_A15_S135/1Chimeric.out.junction --output_dir output/TS_pilot_smartseq_Chim_Multimap_test_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_cMN_10/B107809_A15_S135/star_fusion 
date
