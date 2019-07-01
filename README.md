# STAR wrapper
Created 19 June 2019

This project aligns fastq files to the genome using STAR, concatenates the `SJ.out.tab` and `Chimeric.out.junction` outputs into one file, and creates a class input file based on the STAR output.

## How to run the script

The script `write_jobs.py` is the main wrapper that runs all necessary jobs. To run on a sample, edit the following variables in the main function:

* `data_path`: set equal to the path containing the fastqs
* `assembly`: set equal to the keyword for the genome assembly you want to use (maybe "mm10" for mouse assembly 10, or hg38 for human assembly 38)
* `gtf_file`: The path to the gtf file that should be used to annotate genes
* `run_name`: The unique name you want to give to the current run. It can be useful to include the date and a signifier for the data
* `r_ends`: list of unique endings for the file names of read one (location 0) and read 2 (location 1)
* `names`: list of unique identifiers for each fastq; e.g. file location for read 1 should be <data_path><name><r_ends[0]> and file location for read 2 should be <data_path><name><r_ends[1]>
    
After assigning these variables, run `python3 write_jobs.py` to submit the jobs.

## Description of output

The output will appear in `output/<run_name>`. This folder will contain a folder for each variable in `names`, so a different folder for each pair of fastq files. Each of these sub-folders contains the following:

* The STAR output. Based on the parameters we are running with, this includes  `Aligned.out.sam` and `Chimeric.out.sam` for both reads (among other STAR-generated files)
* `1SJ_Chimeric.out` and `2SJ_Chimeric.out`. Each of these concatenates the respective `SJ.out.tab` and `Chimeric.out.junction` files. However, these two files don't have the same columns, so right now the only columns that are shared are "donor_chromosome", "acceptor_chromosome", "donor_gene", and "acceptor_gene". The rest of the columns from the individual file are still present, but they are left blank for rows that belong to the "other" file. A more complete description of the columns can be found in the STAR manual: http://chagall.med.cornell.edu/RNASEQcourse/STARmanual.pdf
* `class_input.tsv`: This is the created class input file. Each row contains a summary of read 1 and read 2 where read 1 is either Chimeric or contains a gap.
* `wrapper.log`: This file contains the .out and .err outputs from each job run for the given fastq concatenated for ease of looking over the run.

## Decisions to make in the future

Should our pipeline be based on independent alignment of both reads, or alignment in the paired-end read mode? This will depend on which is better for detecting junctions.
