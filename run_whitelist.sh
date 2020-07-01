#!/bin/bash
#
#SBATCH --job-name=whitelist_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003/log_files/whitelist_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003/log_files/whitelist_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003.%j.err
#SBATCH --time=12:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
date
mkdir -p /scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003
umi_tools whitelist --stdin /oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003_R1_001.fastq.gz --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --log2stderr > /oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003_whitelist.txt --plot-prefix=/oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003 
date
