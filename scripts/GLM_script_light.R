#!/usr/bin/env Rscript

## TheGLM script that first predict a per-read probability for each read alignment and then compute an aggregated score for each junction 
require(data.table)
library(glmnet)
#library(glmtlp)
library(tictoc)
library(GenomicAlignments)
library(sparklyr)
library(dplyr)
library(stringr)

tic("Entire code")
# this function is used for adding gene ensembl anmes and htseq counts from STAR output
add_ensembl <- function(assembly,directory,class_input,is.SE){
 
   if (assembly %like% "hg38"){
    gtf_file = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/hg38_gene_name_ids.txt"
  } else if(assembly %like% "Mmur"){ 
    gtf_file = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/Mmur3_gene_name_ids.txt"
  }
  
  ######## read in gtf file ################
  gtf_info = fread(gtf_file,sep = "\t",header = TRUE)
  gtf_info = gtf_info[!(duplicated(gene_name))]
  ##########################################
  
  
  if(is.SE == 1){
    genecount_file = paste(directory,list.files(directory, pattern = "2ReadsPerGene.out.tab", all.files = FALSE),sep = "")
  } else {
    genecount_file = paste(directory,list.files(directory, pattern = "1ReadsPerGene.out.tab", all.files = FALSE),sep = "")
  }
  ######### read in gene count file #######
  gene_count = fread(genecount_file,sep = "\t",header = FALSE)
  if (assembly %like% "hg38"){
    if (! ("ensembl_id" %in% names(gene_count)) ){  
      gene_count = gene_count[V1%like%"ENSG"]
      gene_count[,ensembl_id:=strsplit(V1,split = ".",fixed = TRUE)[[1]][1],by = 1:nrow(gene_count)]
    }
    if ("gene_name" %in% names(gene_count)){
      gene_count[,gene_name := NULL]  # if there is a gene name column from the past in the file, we want to delete it to avoid errors
    }
  }
  
  if (assembly %like% "Mmur"){
    if (! ("ensembl_id" %in% names(gene_count)) ){  
      gene_count = gene_count[V1%like%"gene"]
      gene_count[,ensembl_id:=strsplit(V1,split = ".",fixed = TRUE)[[1]][1],by = 1:nrow(gene_count)]
    }
    if ("gene_name" %in% names(gene_count)){
      gene_count[,gene_name := NULL]  # if there is a gene name column from the past in the file, we want to delete it to avoid errors
    }
  }
  ##########################################
  
  
  
  #add HUGO gene names to the gene count file
  gene_count = merge(gene_count,gtf_info,by.x = "ensembl_id",by.y = "gene_id",all.x = TRUE,all.y = FALSE)
  gene_count[,V1 := NULL]
  gene_count[,V5 := NULL]
  gene_count = gene_count[!duplicated(gene_name)]
  gene_count = gene_count[!duplicated(ensembl_id)]
  
  
  # now add gene ensembl and gene counts to the class input file
  if ( "geneR1B_ensembl" %in% names(class_input) ){
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

  class_input = class_input[,c("intron_motif","is.annotated","num_uniq_map_reads","num_multi_map_reads","maximum_SJ_overhang") := NULL]
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
  return(class_input)
}


compare_classinput_STARChimOut <- function(directory,is.SE){
  
  options(scipen = 999)  # this will make sure that the modified coordinates in chimeric or SJ files won't be written in scientific representation as we want to compare them with those in the class input file 
  star_SJ_output_1_file = list.files(directory,pattern = "2SJ.out.tab")
  star_chimeric_output_1_file = list.files(directory,pattern = "2Chimeric.out.junction")
#  star_fusion_file = list.files(directory,pattern = "star-fusion.fusion_predictions.abridged.tsv" , recursive = TRUE)
  
  if (is.SE == 0){
    star_SJ_output_1_file = list.files(directory,pattern = "1SJ.out.tab")
    star_SJ_output_2_file = list.files(directory,pattern = "2SJ.out.tab")
    star_chimeric_output_1_file = list.files(directory,pattern = "1Chimeric.out.junction")
    star_chimeric_output_2_file = list.files(directory,pattern = "2Chimeric.out.junction")
  }
  
  ####### read in files ############
  chimeric1 =  fread(paste(directory,star_chimeric_output_1_file,sep = ""),sep = "\t",header = FALSE)
  star_SJ_output_1 =  fread(paste(directory,star_SJ_output_1_file,sep = ""),sep = "\t",header = FALSE)
#  star_fusion = fread(paste(directory,star_fusion_file,sep = ""),sep = "\t" , header = TRUE)
  #############################
  
  # if the script has been run previously on the class inout file, delete the following columns to avoid duplicate column names
  class_input[,intron_motif:=NULL]
  class_input[,is.annotated:=NULL]
  class_input[,num_uniq_map_reads:=NULL]
  class_input[,num_multi_map_reads:=NULL]
  class_input[,maximum_SJ_overhang:=NULL]
  
  #converting intronic positions to exonic positions for chimeric junction output file for R1 
  chimeric1[V3 == "+", V2_exonic := V2 - 1]
  chimeric1[V3 == "-", V2_exonic := V2 + 1]
  chimeric1[V6 == "+", V5_exonic := V5 + 1]
  chimeric1[V6 == "-", V5_exonic := V5 - 1]
  chimeric1[,junction := paste(V1,V2_exonic,V4,V5_exonic,sep = ":")]
  
  star_SJ_output_1[,junction := paste(V1,V2,V1,V3,sep = ":")]
  
  # building compatible junction coordinates for fusions called by STAR-Fusion
#  if ( nrow(star_fusion)>0 ) {
#    star_fusion[,chr1 := strsplit(LeftBreakpoint,split = ":",fixed = TRUE)[[1]][1],by = 1:nrow(star_fusion)] 
#    star_fusion[,pos1 := strsplit(LeftBreakpoint,split = ":",fixed = TRUE)[[1]][2],by = 1:nrow(star_fusion)]
#    star_fusion[,strand1 := strsplit(LeftBreakpoint,split = ":",fixed = TRUE)[[1]][3],by = 1:nrow(star_fusion)]
#    star_fusion[,chr2 := strsplit(RightBreakpoint,split = ":",fixed = TRUE)[[1]][1],by = 1:nrow(star_fusion)]
#    star_fusion[,pos2 := strsplit(RightBreakpoint,split = ":",fixed = TRUE)[[1]][2],by = 1:nrow(star_fusion)]
#    star_fusion[,strand2 := strsplit(RightBreakpoint,split = ":",fixed = TRUE)[[1]][3],by = 1:nrow(star_fusion)]  
#    star_fusion[,junction := paste(chr1,pos1,chr2,pos2 ,sep = ":")]
#  }
  
  class_input[,min_junc_pos:=min(juncPosR1A,juncPosR1B),by=paste(juncPosR1A,juncPosR1B)] # I do this to consistently have the minimum junc position first in the junction id used for comparing between the class input file and the STAR output file
  class_input[,max_junc_pos:=max(juncPosR1A,juncPosR1B),by=paste(juncPosR1A,juncPosR1B)]
  class_input[fileTypeR1 == "Chimeric",junction_compatible := paste(chrR1A,juncPosR1A,chrR1B,juncPosR1B,sep = ":")]
  class_input[fileTypeR1 == "Aligned",junction_compatible := paste(chrR1A,as.numeric(min_junc_pos) + 1,chrR1B,as.numeric(max_junc_pos) - 1,sep = ":")]
  class_input[,min_junc_pos:=NULL]
  class_input[,max_junc_pos:=NULL]
  
  class_input[fileTypeR1 == "Chimeric",is.STAR_Chim := 1]
  class_input[fileTypeR1 == "Chimeric" & !(junction_compatible %in% chimeric1$junction) ,is.STAR_Chim := 0]
  
  class_input[fileTypeR1 == "Aligned",is.STAR_SJ := 1]
  class_input[fileTypeR1 == "Aligned" & !(junction_compatible %in% star_SJ_output_1$junction) ,is.STAR_SJ := 0] 
  class_input = merge(class_input,star_SJ_output_1[,list(junction,V5,V6,V7,V8,V9)],by.x = "junction_compatible",by.y = "junction",all.x = TRUE,all.y = FALSE )
  
  class_input[fileTypeR1 == "Chimeric", is.STAR_Fusion := 0]
#  if ( nrow(star_fusion)>0 ) {
#    class_input[fileTypeR1 == "Chimeric" & (junction_compatible %in% star_fusion$junction) ,is.STAR_Fusion := 1]
#  }
  
  in_star_chim_not_in_classinput = chimeric1[!(junction %in% class_input$junction_compatible)]
  in_star_SJ_not_in_classinput = star_SJ_output_1[ !(junction %in% class_input$junction_compatible)]
  
  class_input[,junction_compatible := NULL]
  setnames(class_input,old = c("V5","V6","V7","V8","V9"), new = c("intron_motif","is.annotated","num_uniq_map_reads","num_multi_map_reads","maximum_SJ_overhang"))
  ################################################
  
  #### write output files
  write.table(in_star_chim_not_in_classinput,paste(directory,"in_star_chim_not_in_classinput.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
  write.table(in_star_SJ_not_in_classinput,paste(directory,"in_star_SJ_not_in_classinput.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
  return(class_input)
}



compute_class_error <- function(train_class, glm_predicted_prob){
  totalerr = sum(abs(train_class - round(glm_predicted_prob)))
  print (paste("total reads:", length(train_class)))
  print(paste("both negative", sum(abs(train_class+round(glm_predicted_prob))==0), "out of ", length(which(train_class==0))))
  print(paste("both positive", sum(abs(train_class+round(glm_predicted_prob))==2), "out of ", length(which(train_class==1))))
  print(paste("classification errors for glm", totalerr, "out of", length(train_class), totalerr/length(train_class) ))
}

compute_junc_cdf <- function(class_input, p_predicted_column, per_read_column, junc_cdf_column,is.10X){
  # compute the junc_cdf scores
  
  
  names(class_input)[names(class_input)==per_read_column]="per_read_prob"
  names(class_input)[names(class_input)==p_predicted_column]="p_predicted"
  
  class_input[p_predicted==1, p_predicted :=0.999999999999]
  class_input[p_predicted==0, p_predicted :=10^-30]
  class_input[per_read_prob==1, per_read_prob:=0.999999999999]
  class_input[per_read_prob==0, per_read_prob:=10^-30]
  class_input[, log_per_read_prob:=log((1-per_read_prob) / per_read_prob), by = per_read_prob]
  setkey(class_input,refName_newR1)
  iter=10000
  class_input[, sum_log_per_read_prob:= sum(log_per_read_prob), by = refName_newR1]
  if(is.10X == 0){
    mu_i = mean(log( (1-class_input[fileTypeR1 == "Aligned"| (fileTypeR1 == "Chimeric" & (chrR1A == chrR1B) & (gene_strandR1A==gene_strandR1B) &  ((gene_strandR1A== "+" & juncPosR1A < juncPosR1B) | (gene_strandR1A== "-" & juncPosR1A > juncPosR1B)) & abs(juncPosR1A- juncPosR1B)<1000000 )]$per_read_prob)/ class_input[fileTypeR1 == "Aligned"| (fileTypeR1 == "Chimeric" & (chrR1A == chrR1B) & (gene_strandR1A==gene_strandR1B) &  ((gene_strandR1A== "+" & juncPosR1A < juncPosR1B) | (gene_strandR1A== "-" & juncPosR1A > juncPosR1B)) & abs(juncPosR1A- juncPosR1B)<1000000 )]$per_read_prob) )
    var_i = var(log( (1-class_input[fileTypeR1 == "Aligned"| (fileTypeR1 == "Chimeric" & (chrR1A == chrR1B) & (gene_strandR1A==gene_strandR1B) &  ((gene_strandR1A== "+" & juncPosR1A < juncPosR1B) | (gene_strandR1A== "-" & juncPosR1A > juncPosR1B)) & abs(juncPosR1A- juncPosR1B)<1000000 )]$per_read_prob)/ class_input[fileTypeR1 == "Aligned"| (fileTypeR1 == "Chimeric" & (chrR1A == chrR1B) & (gene_strandR1A==gene_strandR1B) &  ((gene_strandR1A== "+" & juncPosR1A < juncPosR1B) | (gene_strandR1A== "-" & juncPosR1A > juncPosR1B)) & abs(juncPosR1A- juncPosR1B)<1000000 )]$per_read_prob) )
    all_per_read_probs = class_input[(fileTypeR1 == "Aligned") | (fileTypeR1 == "Chimeric" & (chrR1A == chrR1B) & (gene_strandR1A==gene_strandR1B) &  ((gene_strandR1A== "+" & juncPosR1A < juncPosR1B) | (gene_strandR1A== "-" & juncPosR1A > juncPosR1B)) & abs(juncPosR1A- juncPosR1B)<1000000 )]$per_read_prob
  } else{
    mu_i = mean(log( (1-class_input[fileTypeR1 == "Aligned" & genomicAlignmentR1 ==1]$per_read_prob)/ class_input[fileTypeR1 == "Aligned" & genomicAlignmentR1 ==1]$per_read_prob) )
    var_i = var(log( (1-class_input[fileTypeR1 == "Aligned" & genomicAlignmentR1 ==1]$per_read_prob)/ class_input[fileTypeR1 == "Aligned" & genomicAlignmentR1 ==1]$per_read_prob) )
    all_per_read_probs = class_input[fileTypeR1 == "Aligned" & genomicAlignmentR1 ==1]$per_read_prob
  }
  num_per_read_probs = length(all_per_read_probs)
  for (num_reads in 1:15){
    rnd_per_read_probs = matrix(0, iter, num_reads)
    rnd_per_read_probs = apply(rnd_per_read_probs,1, function(x) all_per_read_probs[sample(num_per_read_probs, num_reads)])
    rnd_per_read_probs = t(rnd_per_read_probs)
    if(num_reads == 1){
      rnd_per_read_probs = t(rnd_per_read_probs)  # for num_reads =1 I need to transepose twice since first I have a vector
    }
    null_dist = apply(rnd_per_read_probs,1, function(x) 1/( exp(sum(log( (1 - x)/x ))) + 1))
    null_dist[which(null_dist==1)]=0.999999999999
    null_dist[which(null_dist==0)]=10^-30
    class_input[fileTypeR1 == "Aligned" & numReads == num_reads, junc_cdf :=length(which(null_dist <= p_predicted))/iter, by = p_predicted]
  }
  
  class_input[fileTypeR1 == "Aligned" & numReads > 15, junc_cdf :=pnorm(sum_log_per_read_prob, mean = numReads*mu_i, sd = sqrt(numReads*var_i), lower.tail = FALSE), by = refName_newR1]
  
  names(class_input)[names(class_input) == "per_read_prob"] = per_read_column
  names(class_input)[names(class_input) == "p_predicted"] =  p_predicted_column
  names(class_input)[names(class_input) == "junc_cdf"] =  junc_cdf_column
  return(class_input)
}

uniformity_test <- function(dt, min_R1_offset, max_R1_offset) {
  possible_values = data.frame(vals = min_R1_offset:max_R1_offset)
  t=data.frame(table(dt))
  possible_values = merge(possible_values, t, by.x = "vals", by.y = "dt", all.x = TRUE, all.y = FALSE)
  possible_values = data.table(possible_values)
  possible_values[is.na(Freq)]$Freq = 0
  test = chisq.test(possible_values$Freq, simulate.p.value = TRUE,B = 200)
  #  test = chisq.test(possible_values$Freq)
  return(test$p.value)
}

tic("reading inputs:")
###### Input arguments ##############
args = commandArgs(trailingOnly = TRUE)
directory = args[1]
assembly = args[2]
is.SE = as.numeric(args[3])

#####################################

### arguments for debugging ######
is.SE = 0
directory = "/scratch/PI/horence/rob/STAR_wrapper/output/20200331_full_Engstrom_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/Engstrom_sim1_trimmed/"
class_input =  fread("/oak/stanford/groups/horence/Roozbeh/class_input.tsv", nrows = 50000, sep = "\t", header = TRUE)
assembly = "hg38"
##################################

###### read in class input file #####################
#class_input_file = list.files(directory, pattern = "class_input.pq")
#class_input_file = paste(directory, class_input_file,sep = "")
#conf <- spark_config()
#sc <- spark_connect(master = "local",  config = conf)
#class_input_parquet = spark_read_parquet(sc, name = "test", path = class_input_file)
#class_input = as.data.table(class_input_parquet %>% select(matches('id|refName_newR1|readLenR1|fileTypeR1|seqR1|genomicAlignmentR1|entropyR1|refName_ABR1|UMI|barcode|aScoreR1|MR1|SR1|nmmR1|NHR1|cigarR1|spliceDist|geneR1|is.|intron_motif')))  ## convert parquet class input file to a datatable
###############################################

###### read in class input file #####################
#class_input_file = list.files(directory, pattern = "class_input.tsv")
#class_input_file = paste(directory, class_input_file,sep = "")
#class_input =  fread(class_input_file, sep = "\t", header = TRUE)
###############################################





# do deduplication for 10X data
if(directory %like% "10X"){
  class_input = class_input[!duplicated(paste(barcode,UMI,refName_newR1))]
}

###### find the best alignment rank across all aligned reads for each junction ######   
#star_sj_output[, junction:=paste(V1,V2,V1,V3, sep= ":"), by = 1:nrow(star_sj_output)]
#class_input = merge(class_input, star_sj_output[, list(junction,V7,V8)], by.x = "junction_compatible", by.y = "junction", all.x = TRUE, all.y = FALSE)
#class_input[, minHIR1A:=min(HIR1A), by = junction_compatible]
###################################################################################

tic()
setkey(class_input,refName_newR1)
if(is.SE ==0){  # I want to discard those reads that have an unaligned R2 in PE data
  class_input = class_input[!is.na(nmmR2A)]
}
class_input[,c("junc_cdf_glm", "junc_cdf_glm_corrected", "junc_cdf_glmnet", "junc_cdf_glmnet_constrained", "junc_cdf_glmnet_corrected", "junc_cdf_glmnet_corrected_constrained"):=NULL]
class_input[, numReads :=length(unique(id)), by = refName_newR1]
class_input[, chrR1A:=strsplit(refName_newR1, split = ":", fixed = TRUE)[[1]][1], by = refName_newR1]
class_input[, chrR1B:=strsplit(refName_newR1, split = "[:|]")[[1]][5], by = refName_newR1]
class_input[, juncPosR1A:=as.integer(strsplit(refName_newR1, split = ":", fixed = TRUE)[[1]][3]), by = refName_newR1]
class_input[, juncPosR1B:=as.integer(strsplit(refName_newR1, split = ":", fixed = TRUE)[[1]][6]), by = refName_newR1]
class_input[, gene_strandR1A:=strsplit(refName_newR1, split = "[:|]")[[1]][4], by = refName_newR1]
class_input[, gene_strandR1B:=strsplit(refName_newR1, split = ":", fixed = TRUE)[[1]][7], by = refName_newR1]
class_input[, geneR1A_uniq:=strsplit(refName_newR1, split = ":", fixed = TRUE)[[1]][2], by = refName_newR1]
class_input[, geneR1B_uniq:=strsplit(refName_newR1, split = ":", fixed = TRUE)[[1]][5], by = refName_newR1]
#class_input[, intron_length:=abs(juncPosR1A - juncPosR1B), by = refName_newR1]
toc()

## add ensembl ids
#class_input = add_ensembl(assembly,directory,class_input,is.SE)

## compare class inpout file with STAR chimeric and output files
class_input = compare_classinput_STARChimOut(directory,is.SE)


### obtain fragment lengths for chimeric reads for computing length adjusted AS ##########
class_input[fileTypeR1 == "Aligned", length_adj_AS_R1:= aScoreR1B/readLenR1]
class_input[fileTypeR1 == "Chimeric", length_adj_AS_R1 := (aScoreR1A + aScoreR1B)/ (MR1A + MR1B + SR1A + SR1B)]
class_input[, length_adj_AS_R1A:= aScoreR1A / (MR1A + SR1A), by = 1:nrow(class_input)]
class_input[, length_adj_AS_R1B:= aScoreR1B / (MR1B + SR1B), by = 1:nrow(class_input)]
###########################################################################################

### obtain the number of smismatches per alignment ##########
class_input[fileTypeR1 == "Aligned", nmmR1:= nmmR1B]
class_input[fileTypeR1 == "Chimeric", nmmR1:= nmmR1A + nmmR1B]
###########################################################################################


#### obtain junction overlap #########
class_input[, overlap_R1 := min(MR1A,MR1B), by = 1:nrow(class_input)]
class_input[, max_overlap_R1 := max(MR1A,MR1B), by = 1:nrow(class_input)]
class_input[, median_overlap_R1 := as.integer(round(median(overlap_R1))), by = refName_newR1]
min_overlap_R1 = min(class_input$overlap_R1)
max_overlap_R1 = max(class_input$overlap_R1)
class_input[, sd_overlap:=sqrt(var(overlap_R1)), by = refName_newR1]
######################################

### categorical variable for zero mismatches ###########
class_input[, is.zero_nmm := 0]
class_input[nmmR1 ==0, is.zero_nmm := 1]
#######################################################

###### categorical variable for multimapping ###########
class_input[, is.multimapping := 0]
class_input[NHR1B>2, is.multimapping := 1]
#####################################################

###### compute noisy junction score ########
round.bin = 50
class_input[, binR1A:=round(juncPosR1A/round.bin)*round.bin]
class_input[, binR1B:=round(juncPosR1B/round.bin)*round.bin]
class_input[, njunc_binR1A:=length(unique(refName_newR1)), by = paste(binR1A, chrR1A)]
class_input[, njunc_binR1B:=length(unique(refName_newR1)), by = paste(binR1B, chrR1B)]
class_input[, binR1A:= NULL]
class_input[, binR1B:= NULL]
############################################

#### get the number of distinct partners for each splice site ###########
setkey(class_input,refName_newR1)
class_input[, junc_pos1_R1:=paste(chrR1A, juncPosR1A, sep= ":"), by = refName_newR1]
class_input[, junc_pos2_R1:=paste(chrR1B, juncPosR1B, sep= ":"), by = refName_newR1]
class_input[, threeprime_partner_number_R1:=length(unique(junc_pos2_R1)), by = junc_pos1_R1]
class_input[, fiveprime_partner_number_R1:=length(unique(junc_pos1_R1)), by = junc_pos2_R1]
class_input[, junc_pos1_R1:= NULL]
class_input[, junc_pos2_R1:= NULL]
###########################################################################


## the same predictors for R2
if (is.SE == 0){
  ### obtain fragment lengths for chimeric reads for computing length adjusted AS ##########
  class_input[fileTypeR2 == "Aligned", length_adj_AS_R2:= aScoreR2A/readLenR2]
  class_input[fileTypeR2 == "Chimeric", length_adj_AS_R2 := (aScoreR2A + aScoreR2B)/ (MR2A + MR2B + SR2A + SR2B)]
  ###########################################################################################
  
  ### obtain the number of mismatches per alignment ##########
  class_input[fileTypeR2 == "Aligned", nmmR2:= nmmR2A]
  class_input[fileTypeR2 == "Chimeric", nmmR2:= nmmR2A + nmmR2B]
  ##########################################################################
  
  #### obtain junction overlap #########
  class_input[, overlap_R2 := min(MR2A,MR2B), by = 1:nrow(class_input)]
  class_input[, max_overlap_R2 := max(MR2A,MR2B), by = 1:nrow(class_input)]
  ######################################
}

class_input[, cur_weight := NULL]
class_input[, train_class := NULL]
####### Assign pos and neg training data for GLM training #######
n.neg = nrow(class_input[genomicAlignmentR1 ==1 & fileTypeR1 == "Aligned"])
print(paste("number of negative reads with genomicAlignmentR1 ==1 & entropyR1<1 is",nrow(class_input[genomicAlignmentR1 ==1 & entropyR1<1 & fileTypeR1 == "Aligned"])))
print(paste("number of negative reads with genomicAlignmentR1 ==1 & entropyR1<2 is",nrow(class_input[genomicAlignmentR1 ==1 & entropyR1<2 & fileTypeR1 == "Aligned"])))
print(paste("number of negative reads with genomicAlignmentR1 ==1 & entropyR1<3 is",nrow(class_input[genomicAlignmentR1 ==1 & entropyR1<3 & fileTypeR1 == "Aligned"])))
print(paste("number of negative reads with genomicAlignmentR1 ==1 & entropyR1<4 is",nrow(class_input[genomicAlignmentR1 ==1 & entropyR1<4 & fileTypeR1 == "Aligned"])))
print(quantile(class_input[genomicAlignmentR1 ==1 & fileTypeR1 == "Aligned"]$entropyR1,probs = 1:40/40 ))
n.pos = nrow(class_input[genomicAlignmentR1 ==0 & entropyR1>2 & fileTypeR1 == "Aligned"])
print(paste("number of positive reads with genomicAlignmentR1 ==0 & entropyR1>1 is",nrow(class_input[genomicAlignmentR1 ==0 & entropyR1>1 & fileTypeR1 == "Aligned"])))
print(paste("number of positive reads with genomicAlignmentR1 ==0 & entropyR1>2 is",nrow(class_input[genomicAlignmentR1 ==0 & entropyR1>2 & fileTypeR1 == "Aligned"])))
print(paste("number of positive reads with genomicAlignmentR1 ==0 & entropyR1>3 is",nrow(class_input[genomicAlignmentR1 ==0 & entropyR1>3 & fileTypeR1 == "Aligned"])))
print(paste("number of positive reads with genomicAlignmentR1 ==0 & entropyR1>4 is",nrow(class_input[genomicAlignmentR1 ==0 & entropyR1>4 & fileTypeR1 == "Aligned"])))
print(quantile(class_input[genomicAlignmentR1 ==0 & fileTypeR1 == "Aligned"]$entropyR1,probs = 1:40/40 ))

n.neg = min(n.neg,150000)
n.pos = min(n.pos,150000)  # number of positive reads that we want to subsample from the list of all reads
all_neg_reads = which((class_input$genomicAlignmentR1 ==1)  & (class_input$fileTypeR1 == "Aligned"))
all_pos_reads = which((class_input$genomicAlignmentR1 ==0) & (class_input$entropyR1>2) & (class_input$fileTypeR1 == "Aligned"))
class_input[sample(all_neg_reads, n.neg, replace= FALSE), train_class := 0]
class_input[sample(all_pos_reads, n.pos, replace= FALSE), train_class := 1]
#################################################################

toc()

#set the training reads and class-wise weights for the reads within the same class
class.weight = min(n.pos, n.neg)

if (n.pos >= n.neg){
  class_input[train_class == 0, cur_weight := 1]
  class_input[train_class == 1, cur_weight := n.neg / n.pos]
} else {
  class_input[train_class == 0, cur_weight := n.pos/n.neg]
  class_input[train_class == 1, cur_weight := 1]
}
####################################

# Add -1 to the formula to remove the intercept
# x$fitted.values gives the fitted value for the response variable
# x$linear.predictors gives the fitted linear value for the response variable

# predict(x, newdata =,..... ) performs the prediction based on the
# if we use type = "link", it gives the fitted value in the scale of linear predictors, if we use type = "response", it gives the response in the scale of the response variable

if (is.SE == 0){
  regression_formula = as.formula("train_class ~ overlap_R1 * max_overlap_R1 + NHR1B + nmmR1 + MR1A:SR1A + MR1B:SR1B + length_adj_AS_R1 + nmmR2 + length_adj_AS_R2 + NHR2A + entropyR1*entropyR2 + location_compatible + read_strand_compatible")
} else {
  regression_formula = as.formula("train_class ~ overlap_R1 * max_overlap_R1 + NHR1B + nmmR1 + MR1A:SR1A +  MR1B:SR1B + entropyR1 + length_adj_AS_R1 + entropyR1:NHR1B + entropyR1:length_adj_AS_R1")
}

tic("GLM model")
###########################
##### GLM model  ##########
###########################
print("first glm model")
setkey(class_input,refName_newR1)
glm_model = glm( update(regression_formula, ~ . -1), data = class_input[!is.na(train_class)], family = binomial(link= "logit"), weights = class_input[!is.na(train_class), cur_weight])
print(summary(glm_model))

#predict for all per-read alignment in class input
class_input$glm_per_read_prob = predict(glm_model, newdata = class_input, type = "response", se.fit = TRUE)$fit

# compute aggregated score for each junction
class_input[, p_predicted_glm := 1/( exp(sum(log( (1 - glm_per_read_prob)/glm_per_read_prob ))) + 1), by = refName_newR1]

#compute classification error for the trained model
compute_class_error(class_input[!is.na(train_class)]$train_class, class_input[!is.na(train_class)]$glm_per_read_prob)

### compute the junc_cdf scores
is.10X = 0 # we use a different set of random reads for 10x data
if (directory %like% "10X"){
  is.10X=1
}
is.10X = 0   # for now we decided to use the same set of random reads for both 10X and SS
class_input = compute_junc_cdf(class_input , "p_predicted_glm", "glm_per_read_prob", "junc_cdf_glm",is.10X)
print("done with GLM")
toc()

#for PE data we have the option of correcting per-read scores for anomalous reads
if (is.SE==0){
  tic("GLM corrected")
  class_input[, glm_per_read_prob_corrected := glm_per_read_prob]
  class_input[(location_compatible==0 | read_strand_compatible==0), glm_per_read_prob_corrected:=glm_per_read_prob/(1 + glm_per_read_prob)]
  class_input[, p_predicted_glm_corrected := 1/( exp(sum(log( (1 - glm_per_read_prob_corrected)/glm_per_read_prob_corrected ))) + 1), by = refName_newR1]
  
  # compute the junc_cdf scores
  class_input = compute_junc_cdf(class_input , "p_predicted_glm_corrected", "glm_per_read_prob_corrected", "junc_cdf_glm_corrected",is.10X)
  print("done with GLM corrected")
  toc()  
}

######################################
######################################
######################################


######################################
######### GLMnet model  ##############
######################################
tic("GLMnet")
print("now GLMnet model")
x_glmnet = model.matrix(regression_formula, class_input[!is.na(train_class)])
glmnet_model = cv.glmnet(x_glmnet, as.factor(class_input[!is.na(train_class)]$train_class), family =c("binomial"), class_input[!is.na(train_class)]$cur_weight, intercept = FALSE, alpha = 1, nlambda = 50, nfolds = 5 )
print("done with fitting GLMnet")
toc()
print(coef(glmnet_model, s = "lambda.1se"))
print(glmnet_model)

# predict for all read alignments in the class input file
class_input_glmnet = model.matrix(update(regression_formula, refName_newR1 ~ .), class_input)
class_input$glmnet_per_read_prob = predict(glmnet_model, newx = class_input_glmnet, type = "response", s = "lambda.1se", se.fit = TRUE)

# compute the fitted classification error based on training data
compute_class_error(class_input[!is.na(train_class)]$train_class, class_input[!is.na(train_class)]$glmnet_per_read_prob)

# compute aggregated score for each junction
class_input[, p_predicted_glmnet := 1/( exp(sum(log( (1 - glmnet_per_read_prob)/glmnet_per_read_prob ))) + 1), by = refName_newR1]

# compute the junc_cdf scores
class_input = compute_junc_cdf(class_input , "p_predicted_glmnet", "glmnet_per_read_prob", "junc_cdf_glmnet",is.10X)
print("done with GLMnet")


####################################################
######### GLMnet model (constrained)  ##############
####################################################
tic("GLMnet constrained")
print("GLMnet constrained")
x_glmnet = model.matrix(regression_formula, class_input[!is.na(train_class)])
if (is.SE==0){
  glmnet_model_constrained = cv.glmnet(x_glmnet, as.factor(class_input[!is.na(train_class)]$train_class), family =c("binomial"), class_input[!is.na(train_class)]$cur_weight, intercept = FALSE, alpha = 1, nlambda = 50, nfolds = 5, upper.limits=c(rep(Inf,3),0,0, rep(Inf,12)), lower.limits=c(-Inf,0,0, rep(-Inf,2),0, rep(-Inf,3),0,0,0,0, rep(-Inf,4)) )
}else{
  glmnet_model_constrained = cv.glmnet(x_glmnet, as.factor(class_input[!is.na(train_class)]$train_class), family =c("binomial"), class_input[!is.na(train_class)]$cur_weight, intercept = FALSE, alpha = 1, nlambda = 50, nfolds = 5, upper.limits=c(rep(Inf,3),0,0, rep(Inf,7)), lower.limits=c(-Inf,0,0, rep(-Inf,2),0,0, rep(-Inf,4),0) )
}
print("done with fitting GLMnet constrained")
toc()
print(coef(glmnet_model_constrained, s = "lambda.1se"))
print(glmnet_model_constrained)

# predict for all read alignments in the class input file
class_input_glmnet = model.matrix(update(regression_formula, refName_newR1 ~ .), class_input)
class_input$glmnet_per_read_prob_constrained = predict(glmnet_model_constrained, newx = class_input_glmnet, type = "response", s = "lambda.1se", se.fit = TRUE)

# compute the fitted classification error based on training data
compute_class_error(class_input[!is.na(train_class)]$train_class, class_input[!is.na(train_class)]$glmnet_per_read_prob_constrained)

# compute aggregated score for each junction
class_input[, p_predicted_glmnet_constrained:= 1/( exp(sum(log( (1 - glmnet_per_read_prob_constrained)/glmnet_per_read_prob_constrained ))) + 1), by = refName_newR1]


# compute the junc_cdf scores
class_input = compute_junc_cdf(class_input , "p_predicted_glmnet_constrained", "glmnet_per_read_prob_constrained", "junc_cdf_glmnet_constrained",is.10X)
print("done with GLMnet constrained")


if (is.SE==0){
  tic("GLMnet corrected")
  class_input[, glmnet_per_read_prob_corrected := glmnet_per_read_prob]
  class_input[(location_compatible==0 | read_strand_compatible==0), glmnet_per_read_prob_corrected:=glmnet_per_read_prob/(1 + glmnet_per_read_prob)]
  class_input[, p_predicted_glmnet_corrected := 1/( exp(sum(log( (1 - glmnet_per_read_prob_corrected)/glmnet_per_read_prob_corrected ))) + 1), by = refName_newR1]
  
  # compute the junc_cdf scores
  class_input = compute_junc_cdf(class_input , "p_predicted_glmnet_corrected", "glmnet_per_read_prob_corrected", "junc_cdf_glmnet_corrected",is.10X)
  print("done with GLMnet corrected")
  toc()
  
  
  tic("GLMnet corrected constrained")
  class_input[, glmnet_per_read_prob_corrected_constrained := glmnet_per_read_prob_constrained]
  class_input[(location_compatible==0 | read_strand_compatible==0), glmnet_per_read_prob_corrected_constrained:=glmnet_per_read_prob_constrained/(1 + glmnet_per_read_prob_constrained)]
  class_input[, p_predicted_glmnet_corrected_constrained := 1/( exp(sum(log( (1 - glmnet_per_read_prob_corrected_constrained)/glmnet_per_read_prob_corrected_constrained ))) + 1), by = refName_newR1]
  
  
  # compute the junc_cdf scores
  class_input = compute_junc_cdf(class_input , "p_predicted_glmnet_corrected_constrained", "glmnet_per_read_prob_corrected_constrained", "junc_cdf_glmnet_corrected_constrained",is.10X)
  print("done with GLMnet corrected contrained")
  toc()  
}


######################################################
######################################################
#### now we do the two-step GLM for chimeric reads ###
######################################################
######################################################
class_input[, train_class := NULL]
class_input[, cur_weight := NULL]
p_predicted_quantile = quantile(class_input[!(duplicated(refName_newR1)) & (fileTypeR1 == "Chimeric")]$p_predicted_glmnet, probs = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9)) # the percentiles for the scores based on linear GLM
p_predicted_neg_cutoff = p_predicted_quantile[[2]]
p_predicted_pos_cutoff = p_predicted_quantile[[8]]

####### Assign pos and neg training data for GLM training #######
n.neg = nrow(class_input[fileTypeR1 == "Chimeric"][p_predicted_glmnet <= p_predicted_neg_cutoff])
n.pos = nrow(class_input[fileTypeR1 == "Chimeric"][p_predicted_glmnet >= p_predicted_pos_cutoff])
n.neg = min(n.neg,150000)
n.pos = min(n.pos,150000)  # number of positive reads that we want to subsample from the list of all reads
all_neg_reads = which((class_input$fileTypeR1 == "Chimeric") & (class_input$p_predicted_glmnet <= p_predicted_neg_cutoff))
all_pos_reads = which((class_input$fileTypeR1 == "Chimeric") & (class_input$p_predicted_glmnet >= p_predicted_pos_cutoff))
class_input[sample(all_neg_reads, n.neg, replace= FALSE), train_class := 0]
class_input[sample(all_pos_reads, n.pos, replace= FALSE), train_class := 1]
#################################################################

class.weight = min(n.pos, n.neg)
if (n.pos >= n.neg){
  class_input[train_class == 0, cur_weight := 1]
  class_input[train_class == 1, cur_weight := n.neg / n.pos]
} else {
  class_input[train_class == 0, cur_weight := n.pos/n.neg]
  class_input[train_class == 1, cur_weight := 1]
}


################################################################
######## Building the GLMnet for chimeric junctions ############
################################################################
if (is.SE == 0){
  regression_formula = as.formula("train_class ~ overlap_R1 * max_overlap_R1  + nmmR1 + length_adj_AS_R1A + length_adj_AS_R1B + nmmR2 + entropyR1*entropyR2 + length_adj_AS_R2")
} else{
  regression_formula = as.formula("train_class ~ overlap_R1 * max_overlap_R1  + nmmR1 + length_adj_AS_R1A + length_adj_AS_R1B + entropyR1")
}

tic("Two-step GLMnet")
print("Two-step GLMnet model for chimeric junctions")
x_glmnet = model.matrix(regression_formula, class_input[!is.na(train_class)])
glmnet_model = cv.glmnet(x_glmnet, as.factor(class_input[!is.na(train_class)]$train_class), family =c("binomial"), class_input[!is.na(train_class)]$cur_weight, intercept = FALSE, alpha = 1, nlambda = 50, nfolds = 5)
print("done with fitting Two-step GLMnet")
toc()
print(coef(glmnet_model, s = "lambda.1se"))
print(glmnet_model)

# predict for all read alignments in the class input file
class_input[,glmnet_twostep_per_read_prob:=NULL]
class_input[,glmnet_twostep_per_read_prob_constrained:=NULL]
class_input_glmnet = model.matrix(update(regression_formula, refName_newR1 ~ .), class_input[fileTypeR1 == "Chimeric"])
class_input[,glmnet_twostep_per_read_prob:=0]
a= predict(glmnet_model, newx = class_input_glmnet, type = "response", s = "lambda.1se", se.fit = TRUE)
class_input[fileTypeR1 == "Chimeric",glmnet_twostep_per_read_prob :=a]
# compute the fitted classification error based on training data
compute_class_error(class_input[!is.na(train_class)]$train_class, class_input[!is.na(train_class)]$glmnet_twostep_per_read_prob)


# compute the fitted classification error based on training data
compute_class_error(class_input[!is.na(train_class)]$train_class, class_input[!is.na(train_class)]$glmnet_twostep_per_read_prob)

# compute aggregated score for each junction
class_input[fileTypeR1 == "Chimeric", p_predicted_glmnet_twostep:= 1/( exp(sum(log( (1 - glmnet_twostep_per_read_prob)/glmnet_twostep_per_read_prob ))) + 1), by = refName_newR1]


# compute the junc_cdf scores
class_input[p_predicted_glmnet_twostep==1, p_predicted_glmnet_twostep:=0.999999999999]
class_input[p_predicted_glmnet_twostep==0, p_predicted_glmnet_twostep:=10^-30]
class_input[glmnet_twostep_per_read_prob==1, glmnet_twostep_per_read_prob:=0.999999999999]
class_input[glmnet_twostep_per_read_prob==0, glmnet_twostep_per_read_prob:=10^-30]
class_input[, log_per_read_prob:=log((1-glmnet_twostep_per_read_prob) / (glmnet_twostep_per_read_prob)), by = glmnet_twostep_per_read_prob]
class_input[, sum_log_per_read_prob:= sum(log_per_read_prob), by = refName_newR1]
mu_i = mean(log( (1-class_input[fileTypeR1 == "Chimeric"]$glmnet_twostep_per_read_prob)/(class_input[fileTypeR1 == "Chimeric"]$glmnet_twostep_per_read_prob)) )
var_i = var(log( (1-class_input[fileTypeR1 == "Chimeric"]$glmnet_twostep_per_read_prob)/(class_input[fileTypeR1 == "Chimeric"]$glmnet_twostep_per_read_prob)) )

iter=10000
all_per_read_probs = class_input[fileTypeR1 == "Chimeric"]$glmnet_twostep_per_read_prob
num_per_read_probs = length(all_per_read_probs)
for (num_reads in 1:15){
  rnd_per_read_probs = matrix(0, iter, num_reads)
  rnd_per_read_probs = apply(rnd_per_read_probs,1, function(x) all_per_read_probs[sample(num_per_read_probs, num_reads)])
  rnd_per_read_probs = t(rnd_per_read_probs)
  if(num_reads == 1){
    rnd_per_read_probs = t(rnd_per_read_probs)  # for num_reads =1 I need to transepose twice since first I have a vector
  }
  null_dist = apply(rnd_per_read_probs,1, function(x) 1/( exp(sum(log( (1 - x)/x ))) + 1))
  null_dist[which(null_dist==1)]=0.999999999999
  null_dist[which(null_dist==0)]=10^-30
  class_input[fileTypeR1 == "Chimeric" & numReads == num_reads, junc_cdf_glmnet_twostep:=length(which(null_dist <= p_predicted_glmnet_twostep))/iter, by = p_predicted_glmnet_twostep]
}
class_input[fileTypeR1 == "Chimeric" & numReads > 15, junc_cdf_glmnet_twostep:=pnorm(sum_log_per_read_prob, mean = numReads*mu_i, sd = sqrt(numReads*var_i), lower.tail = FALSE), by = refName_newR1]


tic("Two-step GLMnet constrained")
print("Two-step GLMnet constrained")
x_glmnet = model.matrix(regression_formula, class_input[!is.na(train_class)])
if (is.SE == 0){
  glmnet_model_constrained = cv.glmnet(x_glmnet, as.factor(class_input[!is.na(train_class)]$train_class), family =c("binomial"), class_input[!is.na(train_class)]$cur_weight, intercept = FALSE, alpha = 1, nlambda = 50, nfolds = 5, upper.limits = c(rep(Inf,3),0, rep(Inf,8)), lower.limits = c(-Inf,0,0,-Inf,0,0,-Inf,0,0,-Inf,-Inf,-Inf))
}else{
  glmnet_model_constrained = cv.glmnet(x_glmnet, as.factor(class_input[!is.na(train_class)]$train_class), family =c("binomial"), class_input[!is.na(train_class)]$cur_weight, intercept = FALSE, alpha = 1, nlambda = 50, nfolds = 5, upper.limits = c(rep(Inf,3),0, rep(Inf,4)), lower.limits = c(-Inf,0,0,-Inf,0,0,0,-Inf))
}
print("done with fitting Two-step GLMnet constrained")
print(coef(glmnet_model_constrained, s = "lambda.1se"))
print(glmnet_model)
toc()

# predict for all read alignments in the class input file
class_input_glmnet_constrained = model.matrix(update(regression_formula, refName_newR1 ~ .), class_input[fileTypeR1 == "Chimeric"])
class_input[,glmnet_twostep_per_read_prob_constrained:=0]
a = predict(glmnet_model_constrained, newx = class_input_glmnet_constrained, type = "response", s = "lambda.1se", se.fit = TRUE)
class_input[fileTypeR1 == "Chimeric",glmnet_twostep_per_read_prob_constrained:=a]

# compute the fitted classification error based on training data
compute_class_error(class_input[!is.na(train_class)]$train_class, class_input[!is.na(train_class)]$glmnet_twostep_per_read_prob_constrained)

# compute aggregated score for each junction
class_input[fileTypeR1 == "Chimeric", p_predicted_glmnet_twostep_constrained:= 1/( exp(sum(log( (1 - glmnet_twostep_per_read_prob_constrained)/glmnet_twostep_per_read_prob_constrained ))) + 1), by = refName_newR1]
######################################
######################################

setkey(class_input,refName_newR1)
class_input[, frac_genomic_reads :=mean(genomicAlignmentR1), by = refName_newR1]

# compute the average of read-level quantities for having a single quantity at the junction level
#class_input[, ave_min_junc_14mer:=mean(min_junc_14mer), by = refName_newR1]
#class_input[, ave_max_junc_14mer:=mean(max_junc_14mer), by = refName_newR1]

class_input[, ave_AT_run_R1:=mean(AT_run_R1), by = refName_newR1]
class_input[, ave_GC_run_R1:=mean(GC_run_R1), by = refName_newR1]
class_input[, ave_max_run_R1:=mean(max_run_R1), by = refName_newR1]

class_input[, ave_entropyR1:=mean(entropyR1), by = refName_newR1]
class_input[, min_entropyR1:=min(entropyR1), by = refName_newR1]

if (is.SE == 0){
  class_input[, frac_anomaly:=0]
  class_input[(location_compatible==0 | read_strand_compatible==0), frac_anomaly:=.N/numReads, by = refName_newR1] # the fraction of anomalous reads for each junction
  class_input[, ave_AT_run_R2:=mean(AT_run_R2), by = refName_newR1]
  class_input[, ave_GC_run_R2:=mean(GC_run_R2), by = refName_newR1]
  class_input[, ave_max_run_R2:=mean(max_run_R2), by = refName_newR1]
  class_input[, ave_entropyR2:=mean(entropyR2), by = refName_newR1]
  class_input[, min_entropyR2:=min(entropyR2), by = refName_newR1]
}


### compute p-value for how close is the median overlap to what we expect based on the read length
iter=5000
tic("junc_median_p_val")
for (num_reads in 1:15){
  rnd_overlaps = matrix(0, iter, num_reads)
  rnd_overlaps = apply(rnd_overlaps,1, function(x) sample(min_overlap_R1:max_overlap_R1, num_reads))
  rnd_overlaps = t(rnd_overlaps)
  if(num_reads == 1){
    rnd_overlaps = t(rnd_overlaps)  # for num_reads=1 I need to transepose twice since first I have a vector
  }
  null_dist_medians = apply(rnd_overlaps,1, function(x) median(x))
  class_input[numReads == num_reads, p_val_median_overlap_R1:=length(which(null_dist_medians >= median_overlap_R1))/iter, by = median_overlap_R1]
}
class_input[numReads > 15, p_val_median_overlap_R1:=pnorm(median_overlap_R1, mean = (min_overlap_R1+max_overlap_R1)/2, sd = sqrt( ((max_overlap_R1-min_overlap_R1+1)^2-1) /12), lower.tail = TRUE), by = refName_newR1]
toc()
#####################################


###################################################
## compute p-value for the uniformity test ########
tic("uniformity test")
#class_input[numReads > 1 & numReads < 15 & (p_predicted_glmnet_twostep > 0.9 | p_predicted_glmnet > 0.85), uniformity_test_pval:=uniformity_test(overlap_R1, min_overlap_R1, max_overlap_R1), by = refName_newR1]
toc()
##################################################
##################################################

col_names_to_keep_in_junc_pred_file = c("refName_newR1","frac_genomic_reads","numReads","njunc_binR1B","njunc_binR1A","median_overlap_R1","threeprime_partner_number_R1","fiveprime_partner_number_R1","is.STAR_Chim","is.STAR_SJ","is.STAR_Fusion","is.True_R1","geneR1A_expression_stranded","geneR1A_expression_unstranded","geneR1B_expression_stranded","geneR1B_expression_unstranded","geneR1B_ensembl","geneR1A_ensembl","geneR1B_uniq","geneR1A_uniq","intron_motif","is.TRUE_fusion","p_predicted_glm","p_predicted_glm_corrected","p_predicted_glmnet","p_predicted_glmnet_constrained","p_predicted_glmnet_corrected","p_predicted_glmnet_corrected_constrained","p_predicted_glmnet_twostep","p_predicted_glmnet_twostep_constrained","junc_cdf_glm","junc_cdf_glmnet","junc_cdf_glmnet_constrained","junc_cdf_glmnet_corrected","junc_cdf_glmnet_corrected_constrained","junc_cdf_glm_corrected","junc_cdf_glmnet_twostep","ave_max_junc_14mer","ave_min_junc_14mer","frac_anomaly","ave_AT_run_R1","ave_GC_run_R1","ave_max_run_R1","ave_AT_run_R2","ave_GC_run_R2","ave_entropyR1","ave_entropyR2","min_entropyR1","min_entropyR2","ave_max_run_R2","sd_overlap","p_val_median_overlap_R1","chrR1A","chrR1B","juncPosR1A","juncPosR1B","gene_strandR1A","gene_strandR1B","fileTypeR1")
junction_prediction = unique(class_input[, colnames(class_input)%in%col_names_to_keep_in_junc_pred_file, with = FALSE])
junction_prediction = junction_prediction[!(duplicated(refName_newR1))]

#### compute emp.p values based upon different junc_cdfs and using those junctions that have at least 10% genomic reads
null_dist = junction_prediction[is.na(is.STAR_Chim) & frac_genomic_reads > 0.1]$junc_cdf_glm
junction_prediction[, emp.p_glm :=length(which(null_dist>junc_cdf_glm))/length(null_dist), by = junc_cdf_glm]
null_dist = junction_prediction[is.na(is.STAR_Chim) & frac_genomic_reads > 0.1]$junc_cdf_glmnet
junction_prediction[, emp.p_glmnet :=length(which(null_dist>junc_cdf_glmnet))/length(null_dist), by = junc_cdf_glmnet]
null_dist = junction_prediction[is.na(is.STAR_Chim) & frac_genomic_reads > 0.1]$junc_cdf_glmnet_constrained
junction_prediction[, emp.p_glmnet_constrained:=length(which(null_dist>junc_cdf_glmnet_constrained))/length(null_dist), by = junc_cdf_glmnet_constrained]


if (is.SE == 0){
  null_dist = junction_prediction[is.na(is.STAR_Chim) & frac_genomic_reads>0.1]$junc_cdf_glm_corrected
  junction_prediction[, emp.p_glm_corrected:=length(which(null_dist>junc_cdf_glm_corrected))/length(null_dist), by = junc_cdf_glm_corrected]
  null_dist = junction_prediction[is.na(is.STAR_Chim) & frac_genomic_reads>0.1]$junc_cdf_glmnet_corrected
  junction_prediction[, emp.p_glmnet_corrected:=length(which(null_dist>junc_cdf_glmnet_corrected))/length(null_dist), by = junc_cdf_glmnet_corrected]
  null_dist = junction_prediction[is.na(is.STAR_Chim) & frac_genomic_reads>0.1]$junc_cdf_glmnet_corrected_constrained
  junction_prediction[, emp.p_glmnet_corrected_constrained:=length(which(null_dist>junc_cdf_glmnet_corrected_constrained))/length(null_dist), by = junc_cdf_glmnet_corrected_constrained]
  
}

tic("add_junc_seq")

## add junction sequence to the glm report file
class_input_extract = class_input[, list(refName_newR1, seqR1, cigarR1A, cigarR1B)]
setkey(class_input_extract,cigarR1A)
class_input_extract[, readoverhang1_length:=sum(explodeCigarOpLengths(cigarR1A, ops=c("I", "S","M"))[[1]]), by = cigarR1A]
setkey(class_input_extract,cigarR1B)
class_input_extract[, readoverhang2_length:=sum(explodeCigarOpLengths(cigarR1B, ops=c("I", "S","M"))[[1]]), by = cigarR1B]
class_input_extract[, overlap:=min(readoverhang1_length, readoverhang2_length), by = 1:nrow(class_input_extract)]   # I do these steps as I want to get the junction sequence based on the most balanced read alignment for the junction (the one that has the highest overlap) 
class_input_extract[, max_junc_level_overlap:=max(overlap), by = refName_newR1]  # the maximum overlap across all reads aligned to the junction 
class_input_extract = class_input_extract[overlap==max_junc_level_overlap]
class_input_extract[, c("overlap","max_junc_level_overlap"):= NULL]
class_input_extract = class_input_extract[!duplicated(refName_newR1)]
junction_prediction = merge(junction_prediction, class_input_extract, by.x = "refName_newR1", by.y = "refName_newR1", all.x = TRUE, all.y = FALSE)
toc()

## removing redundant columns for GLM script
class_input[,c("cur_weight","train_class","sum_log_per_read_prob","log_per_read_prob","junc_cdf1_glm","junc_cdf1_glm_corrected","junc_cdf1_glmnet","junc_cdf1_glmnet_corrected","junc_cdf1_glmnet_twostep","refName_readStrandR1","refName_readStrandR2","gene_strandR1A_new","gene_strandR1B_new"):=NULL]
junction_prediction[, c("cigarR1A","cigarR1B","readoverhang1_length","readoverhang2_length"):= NULL]

write.table(junction_prediction, paste(directory,"GLM_output.txt", sep = ""), row.names = FALSE, quote = FALSE, sep = "\t")
write.table(class_input, paste(directory,"class_input.tsv", sep = ""), row.names = FALSE, quote = FALSE, sep = "\t")

toc()

# ######################################
# ####### now glmtlp model  ############
# tic("glmtlp")
# print("now glmtlp model")
# glmtlp_model = cv.glmTLP(x_glmnet, as.factor(training_reads$train_class), family =c("binomial"), training_reads$cur_weight, intercept = FALSE, tau = 1, nlambda = 100, nfolds = 3)
# training_reads$glmtlp_per_read_prob = predict(glmtlp_model, newx = x_glmnet, type = "response", s= "lambda.1se", se.fit = TRUE)  # predict()$fit gives the fitted linear values. it is the same as the x$linear.predictors
# toc()
# compute_class_error(training_reads$train_class, training_reads$glmtlp_per_read_prob)
# print(coef(glmtlp_model, s = "lambda.1se"))
# print(glmtlp_model)
# 
# # predict for all read alignments in the class input file
# class_input$glmtlp_per_read_prob = predict(glmtlp_model, newx = class_input_glmnet, type = "response", s = "lambda.1se", se.fit = TRUE)
# 
# # compute aggregated score for each junction
# class_input[, p_predicted_glmtlp:= 1/( exp(sum(log( (1 - glmtlp_per_read_prob)/glmtlp_per_read_prob ))) + 1), by = refNameR1]
# ######################################
# ######################################
