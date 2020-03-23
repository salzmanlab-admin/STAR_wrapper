#!/bin/bash
#
#SBATCH --job-name=class_input_SRR11241254
#SBATCH --output=output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/log_files/class_input_SRR11241254.%j.out
#SBATCH --error=output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/log_files/class_input_SRR11241254.%j.err
#SBATCH --time=48:00:00
#SBATCH -p horence,owners
#SBATCH --nodes=1
#SBATCH --mem=250Gb
date
python3 scripts/light_class_input.py --outpath output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/ --assembly hg38_covid19 --bams output/20200317_covid19_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR11241254/2Aligned.out.bam 
date
