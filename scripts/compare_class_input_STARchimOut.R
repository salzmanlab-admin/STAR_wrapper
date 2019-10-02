#!/bin/bash
#############################
# File Name : class_input_chimeric_star.r
#
# Purpose : Compares the chimeric junction in the class input file built based upon the STAR output files and the chimeric junctions  by STAR 
#
# Creation Date : 01-07-2019
#
# Last Modified : Thu 04 Jul 2019 01:35:06 AM PDT
#
# Created By : Roozbeh Dehghannasiri
#
##############################

library(data.table)
library(stringr)
library(dplyr)

args = commandArgs(trailingOnly = TRUE)

###### input files #############
directory = args[1]
is_SE = as.numeric(args[2])
################################

####### inputs for debugging ##############
#directory = "/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_demultiplexed_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"
#is_SE = 1
###########################################

options(scipen = 999)  # this will make sure that the modified coordinates in chimeric or SJ files won't be written in scientific representation as we want to compare them with those in the class input file 
class_input_file = list.files(directory,pattern = "class_input_WithinBAM.tsv")
star_SJ_output_1_file = list.files(directory,pattern = "2SJ.out.tab")
star_chimeric_output_1_file = list.files(directory,pattern = "2Chimeric.out.junction")
star_fusion_file = list.files(directory,pattern = "star-fusion.fusion_predictions.abridged.tsv" , recursive = TRUE)

if (is_SE == 0){
  star_SJ_output_1_file = list.files(directory,pattern = "1SJ.out.tab")
  star_SJ_output_2_file = list.files(directory,pattern = "2SJ.out.tab")
  star_chimeric_output_1_file = list.files(directory,pattern = "1Chimeric.out.junction")
  star_chimeric_output_2_file = list.files(directory,pattern = "2Chimeric.out.junction")
}

####### read in files ############
chimeric1 =  fread(paste(directory,star_chimeric_output_1_file,sep = ""),sep = "\t",header = FALSE)
class_input =  fread(paste(directory,class_input_file,sep = ""),sep = "\t",header = TRUE)
star_SJ_output_1 =  fread(paste(directory,star_SJ_output_1_file,sep = ""),sep = "\t",header = FALSE)
star_fusion = fread(paste(directory,star_fusion_file,sep = ""),sep = "\t" , header = TRUE)
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
if ( nrow(star_fusion)>0 ) {
  star_fusion[,chr1 := strsplit(LeftBreakpoint,split = ":",fixed = TRUE)[[1]][1],by = 1:nrow(star_fusion)] 
  star_fusion[,pos1 := strsplit(LeftBreakpoint,split = ":",fixed = TRUE)[[1]][2],by = 1:nrow(star_fusion)]
  star_fusion[,strand1 := strsplit(LeftBreakpoint,split = ":",fixed = TRUE)[[1]][3],by = 1:nrow(star_fusion)]
  star_fusion[,chr2 := strsplit(RightBreakpoint,split = ":",fixed = TRUE)[[1]][1],by = 1:nrow(star_fusion)]
  star_fusion[,pos2 := strsplit(RightBreakpoint,split = ":",fixed = TRUE)[[1]][2],by = 1:nrow(star_fusion)]
  star_fusion[,strand2 := strsplit(RightBreakpoint,split = ":",fixed = TRUE)[[1]][3],by = 1:nrow(star_fusion)]  
  star_fusion[,junction := paste(chr1,pos1,chr2,pos2 ,sep = ":")]
}


class_input[,min_junc_pos:=min(juncPosR1A,juncPosR1B),by=paste(juncPosR1A,juncPosR1B)] # I do this to consistently have the minimum junc position first in the junction id used for comparing between the class input file and the STAR output file
class_input[,max_junc_pos:=max(juncPosR1A,juncPosR1B),by=paste(juncPosR1A,juncPosR1B)]
class_input = data.frame(class_input) 
class_input = class_input[,!(names(class_input) %in% c("intron_motif","is.annotated","num_uniq_map_reads","num_multi_map_reads","maximum_SJ_overhang"))]
class_input = data.table(class_input)
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
if ( nrow(star_fusion)>0 ) {
  class_input[fileTypeR1 == "Chimeric" & (junction_compatible %in% star_fusion$junction) ,is.STAR_Fusion := 1]
}

in_star_chim_not_in_classinput = chimeric1[!(junction %in% class_input$junction_compatible)]
in_star_SJ_not_in_classinput = star_SJ_output_1[ !(junction %in% class_input$junction_compatible)]

class_input[,junction_compatible := NULL]
setnames(class_input,old = c("V5","V6","V7","V8","V9"), new = c("intron_motif","is.annotated","num_uniq_map_reads","num_multi_map_reads","maximum_SJ_overhang"))
################################################

#### write output files
write.table(class_input,paste(directory,"class_input_WithinBAM.tsv",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
write.table(in_star_chim_not_in_classinput,paste(directory,"in_star_chim_not_in_classinput.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
write.table(in_star_SJ_not_in_classinput,paste(directory,"in_star_SJ_not_in_classinput.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t") 