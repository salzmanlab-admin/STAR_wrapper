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
* `single`: Set equal to True if the data is single-end, and False if it is paired-end. Note that currently if `single = True` it is assumed that the single read to be aligned is in the second fastq file (because of the tendancy for droplet protocols to have read 1 contain the barcode and UMI and read 2 contain the sequence that aligns to the genome). This also causes the files to be demultiplexed to create a new fastq file before they're mapped.
    
### Choosing STAR parameters
These parameters modify which combinations of STAR parameters are run. Be careful about including too many; even if you just have two values for each, you will run the pipeline 16 times. If you have 12 samples, then you're running the pipeline 192 times:
* `chimSegmentMin`: A list containing every value of the `--chimSegmentMin` STAR parameter you want to run on. Example: `chimSegmentMin = [12,10]`
* `chimJunctionOverhangMin`: A list containing every value of the `--chimJunctionOverhangMin` STAR parameter you want to run on. Example: `chimJunctionOverhangMin = [13, 10]`
* `alignSJstitchMismatchNmax`: For every value `<x>` in this list, STAR will be run with `--alignSJstitchMismatchNmax <x> -1 <x> <x>`. Example: `alignSJstitchMismatchNmax = [0,1]`
* `chimSegmentReadGapMax`: A list containing every value of the `--chimSegmentReadGapMax` STAR parameter you want to run on. Example: `chimSegmentReadGapMax = [0,3]`

### Choosing which scripts to run
These parameters let you decide which portion of the script you want to run (for example, if you're modifying the `create_class_input.py` script only, so the mapping shouldn't change):
* `run_whitelist`: Set equal to True if you want to run UMI-tools whitelist script to extract cell barcodes and identify the most likely true cell barcodes (will be run only for 10X)
* `run_extract`: Set equal to True if you want to run UMI-tools extract script which removes UMIs from fastq reads and append them to read name
* `run_map`: Set equal to True if you want to run the mapping job, and False otherwise
* `run_star_fusion`: Set equal to True if you want to run the STAR-Fusion, and False otherwise
* `run_ann`: Set equal to True if you want to annotate and concatenate the STAR files, False otherwise
* `run_class`: Set equal to True if you want to create the class input file, false otherwise
* `run_modify_class`: Set equal to True if you want to make consistent junction IDs in which reverse strands and discrepancies between reporting alignments in chimeric and aligned sam files are taken care of.
* `run_ensembl`: Set equal to True if you want to add gene names to the STAR gene count file and add gene ensembl ids and gene counts to the class input file, False otherwise
* `run_compare`: Set equal to True if you want to comapre the junction in the class inpout file with those in the STAR and STAR-Fusion ouput files, false otherwise
* `run_GLM`: Set equal to True if you want to run the GLM step and assign statistical scores to each junction in the class input file. The output of this step is a file named `GLM_output.txt`. 

After assigning these variables, run `python3 write_jobs.py` to submit the jobs.

## Description of output

There will be a separate folder for every combination of STAR parameters that was run. These folders will follow the naming convention `output/<run_name>_cSM_<chimSegmentMin value>_cJOM_<chimJunctionOverhangMin value>_aSJMN_<alignSJstitchMismatchNmax value>_cSRGM_<chimSegmentReadGapMax value>`. Example: `output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_1_cSRGM_3`. Each of these folders will contain a folder for each variable in `names`, so a different folder for each pair of fastq files. Each of these sub-folders contains the following:

### STAR output
Based on the parameters we are running with, this includes  `2Aligned.out.sam`, `2Chimeric.out.sam`, `2Chimeric.out.junction`, `2SJ.out.tab`, and the same files with 1 instead of 2 if the reads are paired-end (among other STAR-generated files).

### Concatenated STAR splice files
The created files are called `1SJ_Chimeric.out` (if the data is paired-end) and `2SJ_Chimeric.out`. Each of these concatenates the respective `SJ.out.tab` and `Chimeric.out.junction` files, and adds columns for the gene names of the donor and acceptor as well as their strands (because we are defining strand to be whatever strand the gene is on, and `?` if there is no gene on either strand or a gene on both strands). However, these two files don't have the same columns, so right now the only columns that are shared are "donor_chromosome", "acceptor_chromosome", "donor_gene", and "acceptor_gene". The rest of the columns from the individual file are still present, but they are left blank for rows that belong to the "other" file. A more complete description of the columns can be found in the STAR manual: http://chagall.med.cornell.edu/RNASEQcourse/STARmanual.pdf

### Class input file
The purpose of the class input files is for each row to contain a summary of read 1 and read 2 for every read where read 1 is either Chimeric or contains a gap. 

### STAR-Fusion files
STAR-Fusion is an additional module developed by STAR authors to call fusion junctions using the Chimeric.out.junction file generated by STAR. All STAR-Fusion output files are written in the star-fusion folder which is placed in the same folder that other STAR output files are written. The final fusion calls by STAR-Fusion can be found in star-fusion.fusion_predictions.abridged.tsv. Currently STAR-Fusion is only run for R1 (even for PE data).

<!---#### Aligned vs Chimeric priority
Each sample folder will contain a filed called `class_input_priorityAlign.tsv` and `class_input_priorityChimeric.tsv`. The only difference between these two files is that in `class_input_priorityAlign.tsv` if a read appears in both `Aligned.out.sam` and `Chimeric.out.sam` the information will be taken from the `Aligned` file; for `class_input_priorityChimeric.tsv` the information will be taken from the `Chimeric` file before the `Aligned` file (this goes for read 1 and read 2). --->

#### Determining whether a read is included in the class input file
For single-end reads, a read is included in the class input file if it is Chimeric (contains the `ch` flag in the BAM file) or has an N in its cigar string (N codes for a base being skipped). For paired-end reads, if read1 is Chimeric or has an N in its cigar string, the read will be included in the class input file. Its line in the class input file will also include information about read 2, regardless of whether r2 is Chimeric/has an N in its CIGAR string or not. Note that if read 1 is not Chimeric and doesn't have an N in its CIGAR string, then read 2 won't be included in the class input file **even if read 2 is Chimeric or has an N in its CIGAR string** (this is something we could change).
<!---For single-end reads, a read is included in the class input file if it is in `Chimeric.out.sam` or if it has an N in its CIGAR string in `Aligned.out.sam` (N codes for a base being skipped). Note that if the read is in both `Aligned.out.sam` and its CIGAR string doesn't have an N, and `Chimeric.out.sam`, then the read won't be included in `class_input_priorityAlign.tsv` but will be included in `class_input_priorityChimerc.tsv`. For paired-end reads, if read 1 is in `1Chimeric.out.sam` or if it has an N in its CIGAR string, the read will be included in the class input file (again, if it also appears in `1Aligned.out.sam` without an N then it won't appear in `class_input_priorityAlign.tsv`). Its line in the class input file will also include information about read 2, regardless of whether r2 is Chimeric/has an N in its CIGAR string or not. Note that if read 1 is not in `1Chimeric.out.sam` and doesn't have an N in its CIGAR string in `1Aligned.out.sam`, the read won't be included in the class input file **even if read 2 is Chimeric or has an N in its CIGAR string** (this is something we could change). ---> 

#### Fields of the class input file

A note on the naming convention for the fields of the class input file: `id` and `class` are the only fields that are necessarily the same for read 1 and read 2. All other fields have `R1` in them if they pertain to read 1, and `R2` in them if they pertain to read 2. For single-end reads, the information for the one read will always show up in the `R1` columns, even if it's actually from the fastq file labeled 2. Then within read 1 and read 2 the columns are split into `A` and `B`. For a read that aligns to two locations (either in the Chimeric file, or with an N in the CIGAR string in the Aligned file), the first portion of the read is referred to as `A`  and the second is referred to as `B`. Here "first portion" means that if you saw the read in the raw fastq file, the first bases in the read would align to the `A` location, and the last bases would align to the `B` location.

If a read is from the Aligned file rather than the Chimeric file, the following columns will have the value `NA`: `flagB`, `posB`, `aScoreB`, `qualB`, `seqB`. If a read doesn't contain a junction, the following columns will **also** have the value `NA`: `strandR2B`, `chrR2B`, `geneR2B`, `readClassR2`, `juncPosR2A`, `juncPosR2B`, `cigarR2B`, `MR2B`, `SR2B`. 

The class input file contains the following fields in the following order:

Note: :whale: indicates that it is safe to use without modification in a model between aligned and chimeric. :octopus: means it is safe to use without modification within chimeric.  

**Refnames for negative-strand genes will have the acceptor first and the donor second**

1. `id`: Read name. Example: `SRR6546273.367739`

2. `class`: **deprecated: see read_strand_compatible and location_compatible** Class defined by read 1 or read 2. For paired end mode, the options are circular, linear, decoy, err (this happens when the strand is ambiguous, because in that case we can't tell if a potential circular junction is a circle or a decoy, since this definition depends on the strand), fusion (read 1 and read 2 are on different chromosomes, or either r1 or r2 is split between two chromosomes), and strandCross (both reads have flags indicating they're both on + or both on -; this is before we correct strandedness by gene location). For single end data the options are lin (linear-type junction), rev (circle-type junction), and fus (part of read maps to one chromosome and part maps to another)
3. `refName_ABR1`: The refName for R1 will always be of the form `<chrR1A>:<geneR1A>:<juncPosR1A>:<gene_strandR1A>|<chrR1B>:<geneR1B>:<juncPosR1B>:<gene_strandR1B>|<readClassR1>`
4. `refName_readStrandR1`: The refName for R1 will always be of the form either `<chrR1A>:<geneR1A>:<juncPosR1A>:<gene_strandR1A>|<chrR1B>:<geneR1B>:<juncPosR1B>:<gene_strandR1B>|<readClassR1>` or `<chrR1B>:<geneR1B>:<juncPosR1B>:<gene_strandR1B>|<chrR1A>:<geneR1A>:<juncPosR1A>:<gene_strandR1A>|<readClassR1>`. Which one of these two it is will be defined by whether the read strand is + (in which case it will be the first one) or the read strand is - (in which case it will be the second one). See the descriptions for these individual columns for more specifics. **Refnames for negative-strand genes will have the acceptor first and the donor second**
5. `refName_ABR2`: The refName for R2 will always be of the form  `<chrR2A>:<geneR2A>:<juncPosR2A>:<gene_strandR2A>|<chrR2B>:<geneR2B>:<juncPosR2B>:<gene_strandR2B>|<readClassR2>`
6. `refName_readStrandR2`: If read 2 is from `2Chimeric.out.sam` or has an N in the CIGAR string, it will have the same format as `refNameR1` except `R2` replaces `R1`. If instead it aligns without gaps/chimera, it's name is `<chrR2A>:<geneR2A>:<gene_strandR2A>`.
7. `fileTypeR1`: equals `Aligned` if the read came from the `1Aligned.out.sam` file, `Chimeric` if it came from the `1Chimeric.out.sam` file.
8. `fileTypeR2`: equals `Aligned` if the read came from the `2Aligned.out.sam` file, `Chimeric` if it came from the `2Chimeric.out.sam` file.
9. `readClassR1`: This is `fus` if read 1 part A and read 1 part B map to different chromosomes. It is `sc`  if the flags of read 1 part A and read 1 part B don't match (they match if they're both in [0,256] or they're both in [16,276]; they don't match otherwise). It is `rev` if the positions are consistent with a circular junction. It is `lin` if the positions are consistent with a linear junction. It is `err` otherwise (this can occur due to `?` occuring as the strand)
10. `readClassR2`: See `readClassR1` and replace read 1 with read 2. If read 2 isn't a junction this will be `NA`.
11. `numNR1`: Number of N in the reference; from the XN tag in the SAM file
12. `numNR2`: Number of N in the reference; from the XN tag in the SAM file
13. `readLenR1`: length of read 1 (including any softclipped portions)
14. `readLenR2`: Length of read 2 (including any softclipped portions)
15. `barcode`: for 10X data this is the barcode found through UMI-tools, otherwise this is NA
16. `UMI`: for 10X data this is the UMI found through UMI-tools, otherwise this is NA
17. `entropyR1`: The entropy of the read calculated based on 5-mers. Let $k_1, \ldots, k_n$ be all the 5-mers in the read sequence (for example, for ACTCCGAGTCCTCCG the 5-mers would be **ACTCC**GAGTCCTCCG, A**CTCCG**AGTCCTCCG, AC**TCCGA**GTCCTCCG, ACT**CCGAG**TCCTCCG, ACTC**CGAGT**CCTCCG, ACTCC**GAGTC**CTCCG, ACTCCG**AGTCC**TCCG, ACTCCGA**GTCCT**CCG, ACTCCGAG**TCCTC**CG, ACTCCGAGT**CCTCC**G, and ACTCCGAGTC**CTCCG**). Then let $N(c)$ equal the number of times the kmer c appears in $k_1, \ldots, k_n$ (for example, CTCCG appears twice in ACTCCGAGTCCTCCG). Then the entropy is defined as $\sum_C -\frac{N(c)}{n}\log\left(\frac{N(c)}{n}\right)$ (here C is the set of unique 5-mers in the read)
18. `entropyR2`: Same as above
19. `seqR1`: The read sequence
20. `seqR2`: The read sequence
21. `read_strand_compatible`: A 1 here indicates that the read strands are compatible, 0 indicates that they're not. This is 1 if `read_strandR1A` doesn't equal `read_strandR2A` and 0 otherwise. Note that this is **only** based on the "A" part of the read; cross-reference with `strand_crossR1` and `strand_crossR2` to verify that all read strands are in accordance. This is NA for single-end reads.
22. `location_compatible`: A 1 here indicates that the locations are compatible, a 0 indicates that they're not. If `readClassR1` is `fus`, this is 1. If `readClassR1` is `sc`, this is 0. If `readClassR1` is `lin` and `read_strandR1` is +, then this is 1 if `posR1A` < `posR2A` and 0 otherwise. If `readClassR1` is `lin` and `read_strandR1` is -, then this is 1 if `posR1A` > `posR2A` and 0 otherwise. if `readClassR1` is `rev`, then this is 1 if `posR2A` is between `posR1A` and `posR1B` and 0 otherwise. Note that this is **only** based on the "A" part of read 2 for right now. This is NA for single-end reads.
23. `strand_crossR1`: Here 1 indicates that there was a strand cross in read 1 (meaning `read_strandR1A` doesn't equal `read_strandR1B`) and 0 indicates that there wasn't a strand cross (meaning the read strands are equal) 
24. `strand_crossR2`: Here 1 indicates that there was a strand cross in read 1 (meaning `read_strandR2A` doesn't equal `read_strandR2B`) and 0 indicates that there wasn't a strand cross (meaning the read strands are equal)
25. `genomicAlignmentR1`: Here 1 indicates that there is a genomic alignment for read 1, and 0 indicates that there is not. 
26. `spliceDist`: the absolute value of the difference between `juncPosR1A` and `juncPosR1B` 
27. `AT_run_R1`: max(the length of the longest run of A's, the length of the longest run of T's). The A's and T's are combined because we could have the sequence or the reverse complement. This is calculated from `seqR1`.
28. `GC_run_R1`: max(the length of the longest run of G's, the length of the longest run of C's). This is calculated from `seqR1`
29. `max_run_R1`: max(`AT_run_R1`, `GC_run_R1`)
30. `AT_run_R2`:  max(the length of the longest run of A's, the length of the longest run of T's). The A's and T's are combined because we could have the sequence or the reverse complement. This is calculated from `seqR2`.
31. `GC_run_R2`: max(the length of the longest run of G's, the length of the longest run of C's). This is calculated from `seqR2`
32. `max_run_R2`: max(`AT_run_R2`, `GC_run_R2`)
33. `chrR1A`: Chromosome that read 1 part A was aligned to
34. `chrR1B`: Chromosome that read 1 part B was aligned to
35. `chrR2A`: Chromosome that read 2 part A was aligned to
36. `chrR2B`: Chromosome that read 2 part B was aligned to
37. `geneR1A`: Gene that read 1 part A was aligned to. If no gene was annotated in that area, it's marked as "unknown". If multiple genes are annotated in this area, it's marked with all of those gene names concatenated with commas in between Example: `Ubb,Gm1821`. Also see the note on the annotation. 
38. `geneR1B`: Gene that read 1 part B was aligned to.
39. `geneR2A`: Gene that read 2 part A was aligned to.
40. `geneR2B`: Gene that read 2 part B was aligned to.
41. `juncPosR1A`: The last position part A of read 1 aligns to before the junction. If `fileTypeR1 = Chimeric`: if `flagR1A` is 0 or 256, this is equal to `posR1A + ` the sum of the M's, N's, and D's in the CIGAR string. If `flagR1A` is 16 or 272 this is equal to `posR1A`. If `fileTypeR1 = Aligned`, then this equals `posR1A` plus the sum of the M's, N's, and D's before the largest N value in the CIGAR string. 
42. `juncPosR1B`: The first position of part B of read 1 that aligns after the junction. If `fileTypeR1 = Chimeric`: if `flagR1B` is 0 or 256, this is equal to `posR1B`. If `flagR1B` is 16 or 272 this is equal to `posR1B + ` the sum of the M's, N's, and D's in the CIGAR string. If `fileTypeR1 = Aligned`, then this equals `posR1B`. 
43. `juncPosR2A`: This follows the same rules as those for read 1, except if the read doesn't contain a junction this is `NA`
44. `juncPosR2B`: This follows the same rules as those for read 1, except if the read doesn't contain a junction this is `NA`
45. `gene_strandR1A`: The strand that the gene at `juncPosR1A` is on (`+` or `-`); if there is no gene at that location, or there is a gene on both strands, this equals `?`.
46. `gene_strandR1B`: The strand that the gene at `juncPosR1B` is on; if there is no gene at that location, or there is a gene on both strands, this equals `?`.
47. `gene_strandR2A`: The strand that the gene at `juncPosR2A` is on; if there is no gene at that location, or there is a gene on both strands, this equals `?`.
48. `gene_strandR2B`: The strand that the gene at `juncPosR2B` is on; if there is no gene at that location, or there is a gene on both strands, this equals `?`.
49. :octopus: `aScoreR1A`: alignment score from the SAM file after the `AS`.
50. :octopus: `aScoreR1B`: alignment score from the SAM file after the `AS`.
51. `aScoreR2A`: alignment score from the SAM file after the `AS`.
52. `aScoreR2B`: alignment score from the SAM file after the `AS`.
53. `flagR1A`: flag from the SAM file; 0 means forward strand primary alignment, 256 means forward strand secondary alignment, 16 means reverse strand primary alignment, 272 means reverse strand secondary alignment.
54. `flagR1B`: flag from the SAM file; 0 means forward strand primary alignment, 256 means forward strand secondary alignment, 16 means reverse strand primary alignment, 272 means reverse strand secondary alignment.
55. `flagR2A`: flag from the SAM file; 0 means forward strand primary alignment, 256 means forward strand secondary alignment, 16 means reverse strand primary alignment, 272 means reverse strand secondary alignment.
56. `flagR2B`: flag from the SAM file; 0 means forward strand primary alignment, 256 means forward strand secondary alignment, 16 means reverse strand primary alignment, 272 means reverse strand secondary alignment.

57. `posR1A`: 1-based leftmost mapping position from the SAM file 
58. `posR1B`: 1-based leftmost mapping position from the SAM file 
59. `posR2A`: 1-based leftmost mapping position from the SAM file 
60. `posR2B`: 1-based leftmost mapping position from the SAM file 
61. `qualR1A`: Mapping quality of the first portion of read 1. From the manual: "The mapping quality MAPQ (column 5) is 255 for uniquely mapping reads, and int(-10\*log10(1-1/Nmap)) for multi-mapping reads" 
62. `qualR1B`: Mapping quality for the second portion of read 1.
63. `qualR2A`: Mapping quality of the first portion of read 2. 
64. `qualR2B`: Mapping quality of the second portion of read 2.
65.`MDR1A`: The MD flag from the SAM file (indicates where mutations, insertions, and delections occur)
66. `MDR1B`: The MD flag from the SAM file (indicates where mutations, insertions, and delections occur)
67. `MDR2A`: The MD flag from the SAM file (indicates where mutations, insertions, and delections occur)
68. `MDR2B`: The MD flag from the SAM file (indicates where mutations, insertions, and delections occur)
69. :octopus: `nmmR1A`: The number of mismatches in the read; calculated by finding the number of times A,C,T or G appears in the MD flag
70. :octopus: `nmmR1B`: The number of mismatches in the read; calculated by finding the number of times A,C,T or G appears in the MD flag
71. `nmmR2A`: The number of mismatches in the read; calculated by finding the number of times A,C,T or G appears in the MD flag
72. `nmmR2B`: The number of mismatches in the read; calculated by finding the number of times A,C,T or G appears in the MD flag
73. `cigarR1A`: The cigar string for portion A (for Chimeric, this is without the softclipped portion that corresponds to B; for Aligned, this is without the long N sequence marking the intron and everything after)
74. `cigarR2B`: The cigar string for portion B
75. `cigarR2A`: The cigar string for portion A
76. `cigarR2B`: The cigar string for portion B
77. :whale: :octopus: `MR1A`: The number of M's in `cigarR1A` (this corresponds to the number of bases that have a match or mismatch with the reference)
78. :whale: :octopus: `MR1B`: The number of M's in `cigarR1B`
79. `MR2A`: The number of M's in `cigarR2A`
80. `MR2B`: The number of M's in `cigarR2B`
81. :whale: :octopus: `SR1A`: The number of S's in `cigarR1A` (this corresponds to the number of bases that have been softclipped)
82. :whale: :octopus: `SR1B`: The number of S's in `cigarR1B`
83. `SR2A`: The number of S's in `cigarR2A`
84. `SR2B`: The number of S's in `cigarR2B`
85. `NHR1A`: Number of reported alignments that contains the query in the current record
86. `NHR1B`: Number of reported alignments that contains the query in the current record
87. `NHR2A`: Number of reported alignments that contains the query in the current record
88. `NHR2B`: Number of reported alignments that contains the query in the current record
89. `HIR1A`: Query hit index, indicating the alignment record is the i-th one stored in SAM
90. `HIR1B`: Query hit index, indicating the alignment record is the i-th one stored in SAM
91. `HIR2A`: Query hit index, indicating the alignment record is the i-th one stored in SAM
92. `HIR2B`: Query hit index, indicating the alignment record is the i-th one stored in SAM
93. :octopus: `nMR1A`: The number of mismatches per (paired) alignment, not to be confused with NM, which is the number of mismatches in each mate
94. :octopus: `nMR1B`: The number of mismatches per (paired) alignment, not to be confused with NM, which is the number of mismatches in each mate
95. `nMR2A`: The number of mismatches per (paired) alignment, not to be confused with NM, which is the number of mismatches in each mate
96. `nMR2B`: The number of mismatches per (paired) alignment, not to be confused with NM, which is the number of mismatches in each mate
97. :octopus: `NMR1A`: Edit distance to the reference, including ambiguous bases but excluding clipping
98. :octopus: `NMR1B`: Edit distance to the reference, including ambiguous bases but excluding clipping
99. `NMR2A`: Edit distance to the reference, including ambiguous bases but excluding clipping
100. `NMR2B`: Edit distance to the reference, including ambiguous bases but excluding clipping
101. :octopus: `jMR1A`: intron motifs for all junctions (i.e. N in CIGAR): 0: non-canonical; 1: GT/AG, 2: CT/AC, 3: GC/AG, 4: CT/GC, 5: AT/AC, 6: GT/AT. If splice junctions database is used, and a junction is annotated, 20 is added to its motif value.
jI:B:I,Start2,End1,Start2,End2,...
102. :octopus: `jMR1B`: intron motifs for all junctions (i.e. N in CIGAR): 0: non-canonical; 1: GT/AG, 2: CT/AC, 3: GC/AG, 4: CT/GC, 5: AT/AC, 6: GT/AT. If splice junctions database is used, and a junction is annotated, 20 is added to its motif value.
jI:B:I,Start1,End1,Start2,End2,...
103. `jMR2A`: intron motifs for all junctions (i.e. N in CIGAR): 0: non-canonical; 1: GT/AG, 2: CT/AC, 3: GC/AG, 4: CT/GC, 5: AT/AC, 6: GT/AT. If splice junctions database is used, and a junction is annotated, 20 is added to its motif value.
jI:B:I,Start1,End1,Start2,End2,...
104. `jMR2B`: intron motifs for all junctions (i.e. N in CIGAR): 0: non-canonical; 1: GT/AG, 2: CT/AC, 3: GC/AG, 4: CT/GC, 5: AT/AC, 6: GT/AT. If splice junctions database is used, and a junction is annotated, 20 is added to its motif value.
jI:B:I,Start1,End1,Start2,End2,...
105. :octopus: `jIR1A`: attributes require samtools 0.1.18 or later, and were reported to be incompatible with some downstream tools such as Cufflink
106. :octopus: `jIR1B`: attributes require samtools 0.1.18 or later, and were reported to be incompatible with some downstream tools such as Cufflink
107. `jIR2A`: attributes require samtools 0.1.18 or later, and were reported to be incompatible with some downstream tools such as Cufflink
108. `jIR2B`: attributes require samtools 0.1.18 or later, and were reported to be incompatible with some downstream tools such as Cufflink
109. `read_strandR1A`: The read strand
110. `read_strandR1B`: The read strand
111. `read_strandR2A`: The read strand
112. `read_strandR2B`: The read strand


### New columns in the class input file after run_ensembl step:
* `geneR1B_ensembl`: the gene ensembl id for `geneR1B`
* `geneR1A_ensembl`: the gene ensembl id for `geneR1A`
* `geneR1B_name`: the HUGO name for `geneR1B`
* `geneR1A_name`: the HUGO name for `geneR1A`
* `geneR1A_expression`: the gene counts (htseq counts) for `geneR1A` according to column V3 in `1ReadsPerGene.out.tab` (`2ReadsPerGene.out.tab` for PE data)
* `geneR1B_expression`: the gene counts (htseq counts) for `geneR1B` according to column V3 in `1ReadsPerGene.out.tab` (`2ReadsPerGene.out.tab` for PE data)

###  Files for comparing the junctions in the class input files with those in the STAR output files:
If run_compare is set to TRUE, junctions in both class input files are comapred with the junctions in the STAR output files `SJ.out.tab` and `Chimeric.out.junction`. Currently, the comaprison is only for junctional R1 reads. At the end of this step 3 columns will be added to each class input file:

* `is.STAR_Chim`: is 1 if a chimeric junction in the class input file is also present in `Chimeric.out.junction`, and is 0 otherwise. (It is NA for all splice alignments in the class inpout file coming from `Aligned.out.sam`) 
* `is.STAR_SJ`: is 1 if a splice junction in the class input file is also present in `SJ.out.tab`, and is 0 otherwise. (It is NA for all * chimeric junctions in the class inpout file coming from `Chimeric.out.sam`)  
* `is.STAR_Fusion`: is 1 if a chimeric junction in the class input file is also present in `star-fusion.fusion_predictions.abridged.tsv` (called by STAR-Fusion), and is 0 otherwise. (It is NA for all splice alignments in the class inpout file coming from `Aligned.out.sam`) 
Also, the following 4 files will be written at the end of this module:
* `in_star_chim_not_in_classinput_priority_Align.txt`: chimeric junctions in the STAR `Chimeric.out.junction` file that cannot be found in `class_input_priorityAlign.tsv`
* `in_star_chim_not_in_classinput_priority_Chim.txt`: chimeric junctions in the STAR `Chimeric.out.junction` file that cannot be found in `class_input_priorityChimeric.tsv`
* `in_star_SJ_not_in_classinput_priority_Align.txt`: splice junctions in the STAR `SJ.out.tab` file that cannot be found in `class_input_priorityAlign.tsv`
* `in_star_SJ_not_in_classinput_priority_Chim.txt`: chimeric junctions in the STAR `SJ.out.tab` file that cannot be found in class_input_priorityChimeric.tsv



### Log files
There is a file called `wrapper.log` in the folder for every pipeline run, as well as for every sample. The goal of these files it to make it easier to look at the output from the jobs you submit with the pipeline by collecting it all in the same place. For example, the folder `output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_0_cSRGM_0` will contain a `wrapper.log` file which has the `.out` and `.err` files concatenated for every job and every sample in that run; these outputs are sorted by job type (so the outputs for the mapping jobs for each sample will be next to each other, etc). There is also a `wrapper.log` file in each sample sub-folder; for example, `output/GSE109774_colon_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/SRR6546273` will contain this file. It contains the output for all `.out` and `.err` outputs from all the jobs run on that specific sample. The `wrapper.log` files are rewritten every time the pipeline is run on a sample.

## A note on annotation

## Decisions to make in the future

Should our pipeline be based on independent alignment of both reads, or alignment in the paired-end read mode? This will depend on which is better for detecting junctions.


