#!/bin/bash
#
#SBATCH --job-name=extract_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003
#SBATCH --output=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003/log_files/extract_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003.%j.out
#SBATCH --error=/scratch/PI/horence/Roozbeh/single_cell_project/output/Krasnow_COVID_10x_pilot3_cSM_10_cJOM_10_aSJMN_-1_cSRGM_0/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003/log_files/extract_lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003.%j.err
#SBATCH --time=20:00:00
#SBATCH -p quake,owners
#SBATCH --nodes=1
#SBATCH --mem=20Gb
#SBATCH --dependency=afterok:3344129
#SBATCH --kill-on-invalid-dep=yes
date
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNNNN --stdin /oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003_R1_001.fastq.gz --stdout /oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003_extracted_R1_001.fastq.gz --read2-in /oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003_R2_001.fastq.gz --read2-out=/oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003_extracted_R2_001.fastq.gz --whitelist=/oak/stanford/groups/krasnow/ktrav/COVID/data10x/sequencing_runs/200603_A00111_0499_BH7WTJDSXY/fastqs/lungSlice_Pilot3_72h_SARS-CoV-2_Sample_2_S8_L003_whitelist.txt --error-correct-cell 
date
