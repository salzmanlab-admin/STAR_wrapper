# STAR wrapper
Created 19 June 2019

This project aligns fastq files to the genome using STAR, concatenates the `SJ.out.tab` and `Chimeric.out.junction` outputs into one file, and creates a class input file based on the STAR output.

## How to run the script

The script `write_jobs.py` is the main wrapper that runs all necessary jobs. To run on a sample, edit the following variables in the main function:

### Inputting sample data
Update the script with information about your sample by inputting the following parameters.
* `data_path`: set equal to the path containing the fastqs. Example: `data_path = "/scratch/PI/horence/JuliaO/single_cell/data/SRA/19.05.31.GSE109774/"`
* `assembly`: set equal to the keyword for the genome assembly you want to use (maybe "mm10" for mouse assembly 10, or hg38 for human assembly 38). Example: `assembly = "mm10"`
* `gtf_file`: The path to the gtf file that should be used to annotate genes. Example: `gtf_file = "/share/PI/horence/circularRNApipeline_Cluster/index/mm10_genes.gtf"`
* `run_name`: The unique name you want to give to the current run. It can be useful to include the date and a signifier for the data. Example: `run_name = "GSE109774_colon"`
* `r_ends`: list of unique endings for the file names of read one (location 0) and read 2 (location 1). Example: `r_ends = ["_1.fastq.gz", "_2.fastq.gz"]`
* `names`: list of unique identifiers for each fastq; e.g. file location for read 1 should be <data_path><name><r_ends[0]> and file location for read 2 should be <data_path><name><r_ends[1]>. Example: `names = ["SRR65462{}".format(i) for i in range(73,74)]`
* `single`: Set equal to True if the data is single-end, and False if it is paired-end. Note that currently if `single = True` it is assumbed that the single read to be aligned is in the second fastq file (because of the tendancy for droplet protocols to have read 1 contain the barcode and UMI and read 2 contain the sequence that aligns to the genome). 
    
### Choosing STAR parameters
These parameters modify which combinations of STAR parameters are run. Be careful about including too many; even if you just have two values for each, you will run the pipeline 16 times. If you have 12 samples, then you're running the pipeline 192 times:
* `chimSegmentMin`: A list containing every value of the `--chimSegmentMin` STAR parameter you want to run on. Example: `chimSegmentMin = [12,10]`
* `chimJunctionOverhangMin`: A list containing every value of the `--chimJunctionOverhangMin` STAR parameter you want to run on. Example: `chimJunctionOverhangMin = [13, 10]`
* `alignSJstitchMismatchNmax`: For every value `<x>` in this list, STAR will be run with `--alignSJstitchMismatchNmax <x> -1 <x> <x>`. Example: `alignSJstitchMismatchNmax = [0,1]`
* `chimSegmentReadGapMax`: A list containing every value of the `--chimSegmentReadGapMax` STAR parameter you want to run on. Example: `chimSegmentReadGapMax = [0,3]`

### Choosing which scripts to run
These parameters let you decide which portion of the script you want to run (for example, if you're modifying the `create_class_input.py` script only, so the mapping shouldn't change):
* `run_map`: Set equal to True if you want to run the mapping job, and False otherwise
* `run_ann`: Set equal to True if you want to annotate and concatenate the STAR files, False otherwise
* `run_class`: Set equal to True if you want to create the class input file, false otherwise
    
After assigning these variables, run `python3 write_jobs.py` to submit the jobs.

## Description of output

There will be a separate folder for every combination of STAR parameters that was run. These folders will follow the naming convention `output/<run_name>_cSM_<chimSegmentMin value>_cJOM_<chimJunctionOverhangMin value>_aSJMN_<alignSJstitchMismatchNmax value>_cSRGM_<chimSegmentReadGapMax value>`. Example: `output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_1_cSRGM_3`. Each of these folders will contain a folder for each variable in `names`, so a different folder for each pair of fastq files. Each of these sub-folders contains the following:

### STAR output
Based on the parameters we are running with, this includes  `2Aligned.out.sam`, `2Chimeric.out.sam`, `2Chimeric.out.junction`, `2SJ.out.tab`, and the same files with 1 instead of 2 if the reads are paired-end (among other STAR-generated files)

### Concatenated STAR splice files
`1SJ_Chimeric.out` and `2SJ_Chimeric.out`. Each of these concatenates the respective `SJ.out.tab` and `Chimeric.out.junction` files. However, these two files don't have the same columns, so right now the only columns that are shared are "donor_chromosome", "acceptor_chromosome", "donor_gene", and "acceptor_gene". The rest of the columns from the individual file are still present, but they are left blank for rows that belong to the "other" file. A more complete description of the columns can be found in the STAR manual: http://chagall.med.cornell.edu/RNASEQcourse/STARmanual.pdf

### Class input file
* `class_input.tsv`: This is the created class input file. Each row contains a summary of read 1 and read 2 where read 1 is either Chimeric or contains a gap.

### Log files
* `wrapper.log`: This file contains the .out and .err outputs from each job run for the given fastq concatenated for ease of looking over the run.

## Decisions to make in the future

Should our pipeline be based on independent alignment of both reads, or alignment in the paired-end read mode? This will depend on which is better for detecting junctions.
