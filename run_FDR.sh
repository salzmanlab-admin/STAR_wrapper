#!/bin/bash
#
#SBATCH --job-name=FDR_calling
#SBATCH --output=job_output/FDR_calling.%j.out
#SBATCH --error=job_output/FDR_calling.%j.err
#SBATCH --time=1:00:00
#SBATCH --account=horence
#SBATCH --partition=horence,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date

ROOZOUT="/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/"

#METHOD="ss2"
#DATA_PATHS="/oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0132_AH3VFJDSXX/salzman_pipeline_output/Lemur_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"

#UNLIM="--unlim_read"

#METHOD="10x"
#DATA_PATHS="${ROOZOUT}TS_pilot_10X_withinbam_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"

#METHOD="ss2"
#DATA_PATHS="${ROOZOUT}TS_pilot_smartseq_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"


METHOD="10x"
DATA_PATHS="${ROOZOUT}HLCA_171205_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/ ${ROOZOUT}HLCA_180607_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"
VALUE=0.9

#METHOD="10x"
#DATA_PATHS="${ROOZOUT}Lemur_Antoine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/" 
#DATA_PATHS="${ROOZOUT}Lemur_Bernard_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/" 
#DATA_PATHS="${ROOZOUT}Lemur_Martine_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/" 
#DATA_PATHS="${ROOZOUT}Lemur_Stumpy_10X_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"

a="python3 -u scripts/FDR_junc_calls.py --method ${METHOD} --data_paths ${DATA_PATHS} --value ${VALUE} --avg_AT --sd_overlap --frac_genomic"
eval $a

date
