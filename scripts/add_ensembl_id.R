library(data.table)
library(stringr)
library(dplyr)

add_ensembl <- function(gene){
  return(synonyms[synonyms$Synonyms %like% gene]$ensemble1)
}


args = commandArgs(trailingOnly = TRUE)

##### input files #########
directory = args[1]
is.single = as.numeric(args[2])
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
if (! ("ensembl_id" %in% names(gene_count)) ){  
  gene_count = gene_count[V1%like%"ENSG"]
  gene_count[,ensembl_id:=strsplit(V1,split = ".",fixed = TRUE)[[1]][1],by = 1:nrow(gene_count)]
}
if ("gene_name" %in% names(gene_count)){
  gene_count[,gene_name := NULL]  # if there is a gene name column from the past in the file, we want to delete it to avoid errors
}
##########################################

######## read in gtf file ################
gtf_info = fread(gtf_file,sep = "\t",header = TRUE)
gtf_info = gtf_info[!(duplicated(gene_name))]
##########################################

########## read in gene synonyms file ######### 
synonyms = fread(synonyms_file,sep = "\t",header = TRUE)
###############################################

#add readable gene names to the gene count file
gene_count = merge(gene_count,gtf_info,by.x = "ensembl_id",by.y = "gene_id",all.x = TRUE,all.y = FALSE)
gene_count[,V1 := NULL]
gene_count[,V5 := NULL]
gene_count = gene_count[!duplicated(gene_name)]
gene_count = gene_count[!duplicated(ensembl_id)]
write.table(gene_count,genecount_file,row.names = FALSE,sep = "\t",quote = FALSE)

# now process both class input files for align_priority and chimeric priority
class_input_files = list.files(directory, pattern = "class_input_WithinBAM", all.files = FALSE)
for (counter in 1:1){
  class_input = fread(paste(directory,class_input_files[counter],sep = ""),sep = "\t",header = TRUE)
#  class_input[,geneR1A := NULL]
#  class_input[,geneR1B := NULL]
#  class_input[,geneR1A := strsplit(strsplit(refName_ABR1,split = "|",fixed = TRUE)[[1]][2],split = ":")[[1]][2],by = 1:nrow(class_input)]
#  class_input[,geneR1B := strsplit(refName_ABR2,split = ":")[[1]][2],by = 1:nrow(class_input)]
  if ( "geneR1B_name" %in% names(class_input) ){
     class_input[,geneR1A_name := NULL]
     class_input[,geneR1B_name := NULL]
     class_input[,geneR1A_ensembl := NULL]
     class_input[,geneR1B_ensembl := NULL]
     class_input[,geneR1A_expression := NULL] 
     class_input[,geneR1B_expression := NULL]
  }
 # class_input[,geneR1B_name := tail(strsplit(geneR1B,split = ",")[[1]],n = 1),by = 1:nrow(class_input)]
 # class_input[,geneR1A_name := tail(strsplit(geneR1A,split = ",")[[1]],n = 1),by = 1:nrow(class_input)]
 
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
  
 # class_input_1 = class_input[is.na(geneR1A_ensembl)]
 # ensemble_ids = apply(class_input_1,1,function(x) synonyms[Synonyms%like%x['geneR1A_name']]$ensemble1[1])
 # class_input[is.na(geneR1A_ensembl)]$geneR1A_ensembl = ensemble_ids
 # class_input_2 = class_input[is.na(geneR1B_ensembl)]
 # ensemble_ids = apply(class_input_2,1,function(x) synonyms[Synonyms%like%x['geneR1B_name']]$ensemble1[1])
 # class_input[is.na(geneR1B_ensembl)]$geneR1B_ensembl = ensemble_ids
  
  write.table(class_input,paste(directory,class_input_files[counter],sep = ""),row.names = FALSE, quote = FALSE, sep = "\t")
}

