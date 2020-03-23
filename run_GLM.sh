#!/bin/bash
#
#SBATCH --job-name=GLM_SRR11241254
#SBATCH --output=output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/log_files/GLM_SRR11241254.%j.out
#SBATCH --error=output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/log_files/GLM_SRR11241254.%j.err
#SBATCH --time=48:00:00
#SBATCH -p horence,owners
#SBATCH --nodes=1
#SBATCH --mem=300Gb
date
ml python/3.6.1
ml R/3.6.1
Rscript scripts/GLM_script_light.R output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/ hg38_covid19  1 
date
