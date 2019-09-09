#!/usr/bin/env Rscript

library(data.table)
library(stringr)
library(dplyr)

args = commandArgs(trailingOnly = TRUE)

##### input files #########
directory = args[1]
is.single = as.numeric(args[2])
gtf_file = "/scratch/PI/horence/Roozbeh/single_cell_project/utility_files/gtf_hg38_gene_name_ids.txt"
######################


######### read in gene count file #######
if(is.single == 1){
  genecount_file = paste(directory,list.files(directory, pattern = "2ReadsPerGene.out.tab", all.files = FALSE),sep = "")
} else {
  genecount_file = paste(directory,list.files(directory, pattern = "1ReadsPerGene.out.tab", all.files = FALSE),sep = "")
}
gene_count = fread(genecount_file,sep = "\t",header = FALSE)
if (! ("ensembl_id" %in% names(gene_count)) ){  
  gene_count = gene_count[V1%like%"ENSG"]
  gene_count[,ensembl_id:=strsplit(V1,split = ".",fixed = TRUE)[[1]][1],by = 1:nrow(gene_count)]
}
if ("gene_name" %in% names(gene_count)){
  gene_count[,gene_name := NULL]  # if there is a gene name column from the past in the file, we want to delete it to avoid errors
}
##########################################

######## read in gtf and class input files ################
gtf_info = fread(gtf_file,sep = "\t",header = TRUE)
gtf_info = gtf_info[!(duplicated(gene_name))]
class_input = fread(paste(directory,"class_input_WithinBAM.tsv",sep = ""),sep = "\t",header = TRUE)
##########################################

#add HUGO gene names to the gene count file
gene_count = merge(gene_count,gtf_info,by.x = "ensembl_id",by.y = "gene_id",all.x = TRUE,all.y = FALSE)
gene_count[,V1 := NULL]
gene_count[,V5 := NULL]
gene_count = gene_count[!duplicated(gene_name)]
gene_count = gene_count[!duplicated(ensembl_id)]


# now add gene ensembl and gene counts to the class input file
if ( "geneR1B_name" %in% names(class_input) ){
  class_input[,geneR1A_name := NULL]
  class_input[,geneR1B_name := NULL]
  class_input[,geneR1A_ensembl := NULL]
  class_input[,geneR1B_ensembl := NULL]
  class_input[,geneR1A_expression_stranded := NULL] 
  class_input[,geneR1B_expression_stranded := NULL]
  class_input[,geneR1A_expression_unstranded := NULL]
  class_input[,geneR1B_expression_unstranded := NULL]
  class_input[,geneR1A_expression := NULL]
  class_input[,geneR1B_expression := NULL]
}

class_input = data.frame(class_input)
class_input = class_input[,!(names(class_input) %in% c("intron_motif","is.annotated","num_uniq_map_reads","num_multi_map_reads","maximum_SJ_overhang"))]
class_input = data.table(class_input)

class_input = merge(class_input,unique(gtf_info[,list(gene_name,gene_id)]),by.x = "geneR1A_uniq",by.y = "gene_name",all.x = TRUE,all.y = FALSE)
setnames(class_input,old = "gene_id" ,new = "geneR1A_ensembl")
class_input = merge(class_input,unique(gtf_info[,list(gene_name,gene_id)]),by.x = "geneR1B_uniq",by.y = "gene_name",all.x = TRUE,all.y = FALSE)
setnames(class_input,old = "gene_id" ,new = "geneR1B_ensembl")

class_input = merge(class_input,gene_count[,list(ensembl_id,V2,V3)],by.x = "geneR1A_ensembl",by.y = "ensembl_id",all.x = TRUE,all.y = FALSE)
setnames(class_input,old = c("V2","V3") ,new = c("geneR1A_expression_unstranded","geneR1A_expression_stranded"))
class_input = merge(class_input,gene_count[,list(ensembl_id,V2,V3)],by.x = "geneR1B_ensembl",by.y = "ensembl_id",all.x = TRUE,all.y = FALSE)
setnames(class_input,old = c("V2","V3") ,new = c("geneR1B_expression_unstranded","geneR1B_expression_stranded"))

## write output files
write.table(gene_count,genecount_file,row.names = FALSE,sep = "\t",quote = FALSE)
write.table(class_input,paste(directory,class_input_files[counter],sep = ""),row.names = FALSE, quote = FALSE, sep = "\t")