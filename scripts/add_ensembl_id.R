library(data.table)
library(stringr)
library(dplyr)

add_ensembl <- function(gene){
  return(synonyms[synonyms$Synonyms %like% gene]$ensemble1)
}


args = commandArgs(trailingOnly = TRUE)

##### input files #########
directory = args[1]
assembly = args[2]
is.single = args[3]
gtf_file = "/scratch/PI/horence/Roozbeh/single_cell_project/utility_files/gtf_hg38_gene_name_ids.txt"
synonyms_file = "/scratch/PI/horence/Roozbeh/single_cell_project/utility_files/synonyms.txt"
######################


######### read in gene count file #######
if(is.single == 1){
  genecount_file = paste(directory,list.files(directory, pattern = "2ReadsPerGene.out.tab", all.files = FALSE),sep = "")
} else {
  genecount_file = paste(directory,list.files(directory, pattern = "1ReadsPerGene.out.tab", all.files = FALSE),sep = "")
}
gene_count = fread(genecount_file,sep = "\t",header = FALSE)
gene_count = gene_count[V1%like%"ENSG"]
gene_count[,ensembl_id:=strsplit(V1,split = ".",fixed = TRUE)[[1]][1],by = 1:nrow(gene_count)]
##########################################

######## read in gtf file ################
gtf_info = fread(gtf_file,sep = "\t",header = TRUE)
gtf_info = gtf_info[!(duplicated(gene_name))]
##########################################

########## read in gene synonyms file ######### 
synonyms = fread(synonyms_file,sep = "\t",header = TRUE)
###############################################

# now process both class input files for align_priority and chimeric priority
class_input_files = list.files(directory, pattern = "class_input", all.files = FALSE)
for (counter in 1:2){
  class_input = fread(paste(directory,class_input_files[counter],sep = ""),sep = "\t",header = TRUE)
  
  class_input[,geneR1B_name := tail(strsplit(geneR1B,split = ",")[[1]],n = 1),by = 1:nrow(class_input)]
  class_input[,geneR1A_name := tail(strsplit(geneR1A,split = ",")[[1]],n = 1),by = 1:nrow(class_input)]
  
  class_input = merge(class_input,unique(gtf_info[,list(gene_name,gene_id)]),by.x = "geneR1A_name",by.y = "gene_name",all.x = TRUE,all.y = FALSE)
  setnames(class_input,old = "gene_id" ,new = "geneR1A_ensembl")
  class_input = merge(class_input,unique(gtf_info[,list(gene_name,gene_id)]),by.x = "geneR1B_name",by.y = "gene_name",all.x = TRUE,all.y = FALSE)
  setnames(class_input,old = "gene_id" ,new = "geneR1B_ensembl")
  
  class_input = merge(class_input,gene_count[,list(ensembl_id,V3)],by.x = "geneR1A_ensembl",by.y = "ensembl_id",all.x = TRUE,all.y = FALSE)
  setnames(class_input,old = "V3" ,new = "geneR1A_expression")
  class_input = merge(class_input,gene_count[,list(ensembl_id,V3)],by.x = "geneR1B_ensembl",by.y = "ensembl_id",all.x = TRUE,all.y = FALSE)
  setnames(class_input,old = "V3" ,new = "geneR1B_expression")
  
  class_input_1 = class_input[is.na(geneR1A_ensembl)]
  ensemble_ids = apply(class_input_1,1,function(x) synonyms[Synonyms%like%x['geneR1A_name']]$ensemble1[1])
  class_input[is.na(geneR1A_ensembl)]$geneR1A_ensembl = ensemble_ids
  class_input_2 = class_input[is.na(geneR1B_ensembl)]
  ensemble_ids = apply(class_input_2,1,function(x) synonyms[Synonyms%like%x['geneR1B_name']]$ensemble1[1])
  class_input[is.na(geneR1B_ensembl)]$geneR1B_ensembl = ensemble_ids
  
  write.table(class_input,paste(directory,class_input_files[counter],sep = ""),row.names = FALSE, quote = FALSE, sep = "\t")
}
