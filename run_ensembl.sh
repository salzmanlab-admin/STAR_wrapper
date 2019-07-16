#!/bin/bash
#
#SBATCH --job-name=ensembl_TSP1_bladder_1_S13_L001_R2
#SBATCH --output=job_output/ensembl_TSP1_bladder_1_S13_L001_R2.%j.out
#SBATCH --error=job_output/ensembl_TSP1_bladder_1_S13_L001_R2.%j.err
#SBATCH --time=12:00:00
#SBATCH -p horence
#SBATCH --nodes=1
#SBATCH --mem=10Gb
date
Rscript scripts/add_ensembl_id.R /scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_demultiplexed_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/TSP1_bladder_1_S13_L001_R2/  hg38 1 
date
