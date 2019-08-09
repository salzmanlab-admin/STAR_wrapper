#!/bin/bash
#
#SBATCH --job-name=fusion_Engstrom_sim1_trimmed
#SBATCH --output=job_output/fusion_Engstrom_sim1_trimmed.%j.out
#SBATCH --error=job_output/fusion_Engstrom_sim1_trimmed.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:47840167
#SBATCH --kill-on-invalid-dep=yes
date
/scratch/PI/horence/Roozbeh/STAR-Fusion/STAR-Fusion --genome_lib_dir /scratch/PI/horence/Roozbeh/STAR-Fusion/GRCh38_gencode_v29_CTAT_lib_Mar272019.plug-n-play/ctat_genome_lib_build_dir/ -J  /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed/1Chimeric.out.junction --output_dir /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed/star_fusion 
date
