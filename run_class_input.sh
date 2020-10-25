#!/bin/bash
#
#SBATCH --job-name=class_input_A10_B000374_B007954_S10
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/log_files/class_input_A10_B000374_B007954_S10.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/log_files/class_input_A10_B000374_B007954_S10.%j.err
#SBATCH --time=48:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=100Gb
#SBATCH --dependency=afterok:18135156
#SBATCH --kill-on-invalid-dep=yes
date
python3 scripts/light_class_input.py --outpath /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/ --gtf /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/ref_Mmur_3.0.gtf --annotator /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/Mmur_3.0.pkl --bams /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/1Aligned.out.bam /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/2Aligned.out.bam --stranded_library --paired 
date
