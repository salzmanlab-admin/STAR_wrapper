#!/bin/bash
#
#SBATCH --job-name=class_input_Engstrom_sim1_trimmed
#SBATCH --output=job_output/class_input_Engstrom_sim1_trimmed.%j.out
#SBATCH --error=job_output/class_input_Engstrom_sim1_trimmed.%j.err
#SBATCH --time=24:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=60Gb
#SBATCH --dependency=afterok:47840167:47840168:47840169
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/create_class_input.py -i /scratch/PI/horence/Roozbeh/single_cell_project/output/Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0_sIO_0_sIB_0/Engstrom_sim1_trimmed/ -a hg38 -g /share/PI/horence/circularRNApipeline_Cluster/index/grch38_genes.gtf 
date
