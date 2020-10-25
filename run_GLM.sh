#!/bin/bash
#
#SBATCH --job-name=GLM_A10_B000374_B007954_S10
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/log_files/GLM_A10_B000374_B007954_S10.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/log_files/GLM_A10_B000374_B007954_S10.%j.err
#SBATCH --time=48:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=100Gb
#SBATCH --dependency=afterok:18135156:18135157
#SBATCH --kill-on-invalid-dep=yes
date
Rscript scripts/GLM_script_light.R /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/ /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/ref_Mmur_3.0.gtf  0  0  0  /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/Mmur_3.0_exon_bounds.pkl /oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_refseq_splices.pkl 
date
