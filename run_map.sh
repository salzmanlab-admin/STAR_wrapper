#!/bin/bash
#
#SBATCH --job-name=map_A10_B000374_B007954_S10
#SBATCH --output=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/log_files/map_A10_B000374_B007954_S10.%j.out
#SBATCH --error=/oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/log_files/map_A10_B000374_B007954_S10.%j.err
#SBATCH --time=24:00:00
#SBATCH --account=horence
#SBATCH --partition=nih_s10
#SBATCH --nodes=1
#SBATCH --mem=60Gb
date
mkdir -p /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --version
/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/Mmur_3.0_index_2.7.5a --readFilesIn /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0132_AH3VFJDSXX/A10_B000374_B007954_S10/A10_B000374_B007954_S10_R1_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/1 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/ref_Mmur_3.0.gtf --outReadsUnmapped Fastx 

/oak/stanford/groups/horence/Roozbeh/software/STAR-2.7.5a/bin/Linux_x86_64/STAR --runThreadN 4 --genomeDir /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/Mmur_3.0_index_2.7.5a --readFilesIn /oak/stanford/groups/krasnow/MLCA/dataSS2/Stumpy_Bernard_SS2/rawdata/180409_A00111_0132_AH3VFJDSXX/A10_B000374_B007954_S10/A10_B000374_B007954_S10_R2_001.fastq.gz --readFilesCommand zcat --twopassMode Basic --alignIntronMax 1000000 --outFileNamePrefix /oak/stanford/groups/horence/Roozbeh/single_cell_project/output/Lemur_smartseq_180409_A00111_0132/A10_B000374_B007954_S10/2 --outSAMtype BAM Unsorted --outSAMattributes All --chimOutType WithinBAM SoftClip Junctions --chimJunctionOverhangMin 10 --chimSegmentReadGapMax 0 --chimOutJunctionFormat 1 --chimSegmentMin 12 --chimScoreJunctionNonGTAG -4 --chimNonchimScoreDropMin 10 --quantMode GeneCounts --sjdbGTFfile /oak/stanford/groups/horence/Roozbeh/single_cell_project/SICILIAN_references/lemur/ref_Mmur_3.0.gtf --outReadsUnmapped Fastx 


date
