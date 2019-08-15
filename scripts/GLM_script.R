#!/usr/bin/env Rscript

## TheGLM script that first predict a per-read probability for each read alignment and then compute an aggregated score for each junction 
require(data.table)
library(glmnet)
library(glmtlp)
library(tictoc)
#library(ggplot2)
#library(plotROC)


compute_class_error <- function(train_class,glm_predicted_prob){
  totalerr = sum(abs(train_class - round(glm_predicted_prob)))
  print (paste("total reads:", length(train_class)))
  print(paste("both negative",sum(abs(train_class+round(glm_predicted_prob))==0), "out of ", length(which(train_class==0))))
  print(paste("both positive",sum(abs(train_class+round(glm_predicted_prob))==2), "out of ", length(which(train_class==1))))
  print(paste("classification errors for glm", totalerr, "out of", length(train_class), totalerr/length(train_class) ))
}

###### Input arguments ##############
args = commandArgs(trailingOnly = TRUE)
directory = args[1]
is.SE = as.numeric(args[2])
#####################################


###### read in class input file #####################
class_input_file = list.files(directory,pattern = "class_input_WithinBAM.tsv")
class_input =  fread(paste(directory,class_input_file,sep = ""),sep = "\t",header = TRUE)
###############################################


###### find the best alignment rank across all aligned reads for each junction ######   
#star_sj_output[,junction:=paste(V1,V2,V1,V3,sep=":"),by=1:nrow(star_sj_output)]
#class_input = merge(class_input,star_sj_output[,list(junction,V7,V8)],by.x = "junction_compatible",by.y="junction",all.x=TRUE,all.y=FALSE)
#class_input[,minHIR1A:=min(HIR1A),by=junction_compatible]
###################################################################################

class_input[,numReads:=length(unique(id)),by = refName_ABR1]

####### Assign pos and neg training data for GLM training #######  
class_input[genomicAlignmentR1==1 & fileTypeR1=="Aligned",train_class := 0]
class_input[genomicAlignmentR1==0 & fileTypeR1=="Aligned",train_class := 1]
#################################################################


### obtain fragment lengths for chimeric reads for computing length adjusted AS ##########
class_input[fileTypeR1 == "Aligned",length_adj_AS_R1:= aScoreR1A/readLenR1]
class_input[fileTypeR1 == "Chimeric",length_adj_AS_R1 := (aScoreR1A + aScoreR1B)/ (MR1A + MR1B + SR1A + SR1B)]
###########################################################################################

### obtain the number of smismatches per alignment ##########
class_input[fileTypeR1 == "Aligned",nmmR1:= nmmR1A]
class_input[fileTypeR1 == "Chimeric",nmmR1:= nmmR1A + nmmR1B]
###########################################################################################

#### obtain mapping quality values for chimeric reads ###################
class_input[fileTypeR1 == "Aligned",qual_R1 := qualR1A]
class_input[fileTypeR1 == "Chimeric",qual_R1 := (qualR1A + qualR1B) / 2]
#########################################################################

#### obtain junction overlap #########
class_input[,overlap_R1 := min(MR1A,MR1B),by=1:nrow(class_input)]
class_input[,max_overlap_R1 := max(MR1A,MR1B),by=1:nrow(class_input)]
######################################

###### compute noisy junction score ########
round.bin = 50
class_input[,binR1A:=round(juncPosR1A/round.bin)*round.bin]
class_input[,binR1B:=round(juncPosR1B/round.bin)*round.bin]
class_input[,njunc_binR1A:=length(unique(refName_readStrandR1)),by=paste(binR1A,chrR1A)]
class_input[,njunc_binR1B:=length(unique(refName_readStrandR1)),by=paste(binR1B,chrR1B)]
############################################

## the same predictors for R2
### obtain fragment lengths for chimeric reads for computing length adjusted AS ##########
class_input[fileTypeR2 == "Aligned",length_adj_AS_R2:= aScoreR2A/readLenR2]
class_input[fileTypeR2 == "Chimeric",length_adj_AS_R2 := (aScoreR2A + aScoreR2B)/ (MR2A + MR2B + SR2A + SR2B)]
###########################################################################################

### obtain the number of mismatches per alignment ##########
class_input[fileTypeR2 == "Aligned",nmmR2:= nmmR2A]
class_input[fileTypeR2 == "Chimeric",nmmR2:=nmmR2A + nmmR2B]
##########################################################################

#### obtain mapping quality values for chimeric reads ###################
class_input[fileTypeR2 == "Aligned",qual_R2 := qualR2A]
class_input[fileTypeR2 == "Chimeric",qual_R2 := (qualR2A + qualR2B) / 2]
#########################################################################

#### obtain junction overlap #########
class_input[,overlap_R2 := min(MR2A,MR2B),by=1:nrow(class_input)]
class_input[,max_overlap_R2 := max(MR2A,MR2B),by=1:nrow(class_input)]
######################################

#### get the number of distinct partners for each splice site ###########
class_input[,junc_pos1:=paste(chrR1A,juncPosR1A,sep=":"),by = 1:nrow(class_input)]
class_input[,junc_pos2:=paste(chrR1B,juncPosR1B,sep=":"),by = 1:nrow(class_input)]
class_input[,threeprime_partner_number:=length(unique(junc_pos2)),by = junc_pos1]
class_input[,fiveprime_partner_number:=length(unique(junc_pos1)),by = junc_pos2]
###########################################################################



################ set the class-level weights for all reads within the same class
n.neg = nrow(class_input[train_class == 0]) 
n.pos = nrow(class_input[train_class == 1])
class.weight = min(n.pos, n.neg)

if (n.pos >= n.neg){
  class_input[train_class == 0,cur_weight := 1]
  class_input[train_class == 1,cur_weight := n.neg / n.pos]
} else {
  class_input[train_class == 0,cur_weight := n.pos/n.neg]
  class_input[train_class == 1,cur_weight := 1]
}
####################################

# Add -1 to the formula to remove the intercept
# x$fitted.values gives the fitted value for the response variable 
# x$linear.predictors gives the fitted linear value for the response variable

# predict(x,newdata = ,..... ) performs the prediction based on the 
# if we use type = "link", it gives the fitted value in the scale of linear predictors, if we use type = "response", it gives the response in the scale of the response variable

if (is.SE == 0){
  regression_formula = as.formula("train_class ~ overlap_R1 * max_overlap_R1 + NHR1A + nmmR1 + MR1A:SR1A +  MR1B:SR1B + entropyR1*entropyR2 + location_compatible + read_strand_compatible + length_adj_AS_R1 + length_adj_AS_R2 + NHR2A + njunc_binR1A + njunc_binR1B")
} else {
  regression_formula = as.formula("train_class ~ overlap_R1 * max_overlap_R1 + NHR1A + nmmR1 + MR1A:SR1A +  MR1B:SR1B + entropyR1 + length_adj_AS_R1  +  njunc_binR1A + njunc_binR1B")
}


######################################
##### first simple glm model  ########
######################################
print("first simple glm model")

tic("glm")
glm_model = glm( update(regression_formula, ~ . -1), data = class_input[!is.na(train_class)], family = binomial(link="logit"), weights = class_input[!is.na(train_class),cur_weight])
toc()
print(summary(glm_model))

#predict for all per-read alignment in class input
class_input$glm_per_read_prob = predict(glm_model,newdata = class_input, type = "response",se.fit = TRUE)$fit 

# compute aggregated score for each junction
class_input[,p_predicted_glm:= 1/( exp(sum(log( (1 - glm_per_read_prob)/glm_per_read_prob ))) + 1) ,by = refName_ABR1]

#compute classification error for the trained model
compute_class_error(class_input[!is.na(train_class)]$train_class,class_input[!is.na(train_class)]$glm_per_read_prob)

# compute aggregated score for each junction
class_input[,p_predicted_glm:= 1/( exp(sum(log( (1 - glm_per_read_prob)/glm_per_read_prob ))) + 1) ,by = refName_ABR1]
print("done with glm")

#for PE data we have the option of correcting per-read scores for anomalous reads
if (is.SE==0){
  class_input[,glm_per_read_prob_corrected := glm_per_read_prob]
  class_input[(location_compatible==0 | read_strand_compatible==0),glm_per_read_prob_corrected:=glm_per_read_prob/(1 + glm_per_read_prob)]
  class_input[,p_predicted_glm_corrected := 1/( exp(sum(log( (1 - glm_per_read_prob_corrected)/glm_per_read_prob_corrected ))) + 1) ,by = refName_ABR1]
}
######################################
######################################
######################################


######################################
######### GLMnet model  ##############
######################################
tic("glmnet")
print("now glmnet model")
x_glmnet = model.matrix(regression_formula, class_input[!is.na(train_class)])
glmnet_model = cv.glmnet(x_glmnet, as.factor(class_input[!is.na(train_class)]$train_class), family=c("binomial"), class_input[!is.na(train_class)]$cur_weight, intercept = FALSE, alpha = 1, nlambda = 40,nfolds = 3)
toc()
print("done with fitting glmnet")

print(coef(glmnet_model, s = "lambda.1se"))
print(glmnet_model)

# predict for all read alignments in the class input file
class_input_glmnet = model.matrix(update(regression_formula, refName_ABR1 ~ .) , class_input)
class_input$glmnet_per_read_prob = predict(glmnet_model,newx = class_input_glmnet, type = "response",s = "lambda.1se", se.fit = TRUE)

# compute the fitted classification error based on training data
compute_class_error(class_input[!is.na(train_class)]$train_class,class_input[!is.na(train_class)]$glmnet_per_read_prob)

# compute aggregated score for each junction
class_input[,p_predicted_glmnet:= 1/( exp(sum(log( (1 - glmnet_per_read_prob)/glmnet_per_read_prob ))) + 1) ,by = refName_ABR1]


if (is.SE==0){
  class_input[,glmnet_per_read_prob_corrected := glmnet_per_read_prob]
  class_input[(location_compatible==0 | read_strand_compatible==0),glmnet_per_read_prob_corrected:=glmnet_per_read_prob/(1 + glmnet_per_read_prob)]
  class_input[,p_predicted_glmnet_corrected := 1/( exp(sum(log( (1 - glmnet_per_read_prob_corrected)/glmnet_per_read_prob_corrected ))) + 1) ,by = refName_ABR1]
}

######################################
######################################

if(is.SE==0){
  junction_predictions = unique(class_input[,list(refName_ABR1,numReads,readClassR1,p_predicted_glm,p_predicted_glmnet,p_predicted_glm_corrected,p_predicted_glmnet_corrected,threeprime_partner_number,fiveprime_partner_number,is.STAR_Chim,is.STAR_SJ,is.STAR_Fusion,geneR1A_expression,geneR1B_expression,geneR1B_ensembl,geneR1A_ensembl,geneR1B_name,geneR1A_name)])
} else{
  junction_predictions = unique(class_input[,list(refName_ABR1,numReads,readClassR1,p_predicted_glm,p_predicted_glmnet,threeprime_partner_number,fiveprime_partner_number,is.STAR_Chim,is.STAR_SJ,is.STAR_Fusion,geneR1A_expression,geneR1B_expression,geneR1B_ensembl,geneR1A_ensembl,geneR1B_name,geneR1A_name)])
}

write.table(junction_predictions,paste(directory,"GLM_output.txt",sep = ""),row.names = FALSE,quote = FALSE,sep = "\t")
#write.table(class_input,paste(directory,"class_input_WithinBAM.txt",sep = ""),row.names = FALSE,quote = FALSE,sep = "\t")


# ######################################
# ####### now glmtlp model  ############
# tic("glmtlp")
# print("now glmtlp model")
# glmtlp_model = cv.glmTLP(x_glmnet, as.factor(training_reads$train_class), family=c("binomial"),training_reads$cur_weight, intercept = FALSE, tau = 1, nlambda = 100,nfolds = 3)
# training_reads$glmtlp_per_read_prob = predict(glmtlp_model,newx = x_glmnet, type = "response",s="lambda.1se", se.fit = TRUE)  # predict()$fit gives the fitted linear values. it is the same as the x$linear.predictors
# toc()
# compute_class_error(training_reads$train_class,training_reads$glmtlp_per_read_prob)
# print(coef(glmtlp_model,s = "lambda.1se"))
# print(glmtlp_model)
# 
# # predict for all read alignments in the class input file
# class_input$glmtlp_per_read_prob = predict(glmtlp_model,newx = class_input_glmnet, type = "response",s = "lambda.1se", se.fit = TRUE)
# 
# # compute aggregated score for each junction
# class_input[,p_predicted_glmtlp:= 1/( exp(sum(log( (1 - glmtlp_per_read_prob)/glmtlp_per_read_prob ))) + 1) ,by = refNameR1]
# ######################################
# ######################################



# ## compute the median of the variables for each junction
# f = data.table(class_input_glmnet)
# f = cbind(class_input$refNameR1,f)
# names(f)[1]="refNameR1"
# f[,median_overlap := round(median(overlap)),by=refNameR1]
# f[,median_max_overlap := round(median(max_overlap)),by=refNameR1]
# f[,median_MR1A := round(median(MR1A)),by=refNameR1]
# f[,median_nmmR1 := round(median(nmmR1)),by=refNameR1]
# f[,median_AS := round(median(nmmR1)),by=refNameR1]
# f[,median_threeprime_num := round(median(threeprime_partner_number)),by=refNameR1]
# f[,median_fiveprime_num := round(median(fiveprime_partner_number)),by=refNameR1]
# f = unique(f[,list(refNameR1,median_overlap,median_max_overlap,median_MR1A,median_nmmR1,median_AS,median_threeprime_num,median_fiveprime_num)])
# names(f) = c("refNameR1","overlap","max_overlap","MR1A","nmmR1","length_adj_AS_R1","threeprime_partner_number","fiveprime_partner_number")
# f_glmnet = model.matrix(refNameR1~overlap + max_overlap + MR1A + nmmR1 + length_adj_AS_R1  + threeprime_partner_number + fiveprime_partner_number , f)
# f$predicted_prob = predict(glmnet_model,newx = f_glmnet, type = "response",s="lambda.1se", se.fit = TRUE)
# f[,class:=strsplit(refNameR1,split = "|",fixed = TRUE)[[1]][3],by = 1:nrow(f)]

