#!/bin/bash
#
#SBATCH --job-name=ann_SJ_Engstrom_sim1_trimmed
#SBATCH --output=job_output/ann_SJ_Engstrom_sim1_trimmed.%j.out
#SBATCH --error=job_output/ann_SJ_Engstrom_sim1_trimmed.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=40Gb
#SBATCH --dependency=afterok:47840167:47840168
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/annotate_SJ.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf 
date
