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


#directory = "/scratch/PI/horence/Roozbeh/single_cell_project/output/TS_pilot_demultiplexed_cSM_10_cJOM_10_aSJMN_0_cSRGM_0/"
#is_SE = 1
#run_set = tail(strsplit(directory,split = "/")[[1]],n = 1)
#dir.create(paste("/scratch/PI/horence/Roozbeh/single_cell_project/class_input_vs_STAR_output_files/",run_set,sep = ""))
options(scipen = 999)  # this will make sure that the modified coordinates in chimeric or SJ files won't be written in scientific representation as we want to compare them with those in the class input file 
class_input_priority_Align_file = list.files(directory,pattern = "class_input_WithinBAM.tsv")
#class_input_priority_Chimeric_file = list.files(directory,pattern = "class_input_priorityChimeric.tsv")
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
class_input_priority_Align =  fread(paste(directory,class_input_priority_Align_file,sep = ""),sep = "\t",header = TRUE)
#class_input_priority_Chimeric =  fread(paste(directory,class_input_priority_Chimeric_file,sep = ""),sep = "\t",header = TRUE)
star_SJ_output_1 =  fread(paste(directory,star_SJ_output_1_file,sep = ""),sep = "\t",header = FALSE)
star_fusion = fread(paste(directory,star_fusion_file,sep = ""),sep = "\t" , header = TRUE)
#############################

  
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
#### first for class_input_priority_Align ####
class_input_priority_Align[fileTypeR1 == "Chimeric",junction_compatible := paste(chrR1A,juncPosR1A,chrR1B,juncPosR1B,sep = ":")]
class_input_priority_Align[fileTypeR1 == "Aligned",junction_compatible := paste(chrR1A,juncPosR1A + 1,chrR1B,juncPosR1B - 1,sep = ":")]
  
class_input_priority_Align[fileTypeR1 == "Chimeric",is.STAR_Chim := 1]
class_input_priority_Align[fileTypeR1 == "Chimeric" & !(junction_compatible %in% chimeric1$junction) ,is.STAR_Chim := 0]

class_input_priority_Align[fileTypeR1 == "Aligned",is.STAR_SJ := 1]
class_input_priority_Align[fileTypeR1 == "Aligned" & !(junction_compatible %in% star_SJ_output_1$junction) ,is.STAR_SJ := 0] 
class_input_priority_Align = merge(class_input_priority_Align,star_SJ_output_1[,list(junction,V5,V6,V7,V8,V9)],by.x = "junction_compatible",by.y = "junction",all.x = TRUE,all.y = FALSE )

class_input_priority_Align[fileTypeR1 == "Chimeric",is.STAR_Fusion := 0]
if ( nrow(star_fusion)>0 ) {
  class_input_priority_Align[fileTypeR1 == "Chimeric" & (junction_compatible %in% star_fusion$junction) ,is.STAR_Fusion := 1]
}

class_input_priority_Align[,junction_compatible := NULL]
setnames(class_input_priority_Align,old = c("V5,V6,V7,V8,V9"),new = c("intron_motif","is.annotated","num_uniq_map_reads","num_multi_map_reads","maximum_SJ_overhang")

in_star_chim_not_in_classinput_prio_align = chimeric1[!(junction %in% class_input_priority_Align$junction_compatible)]
in_star_SJ_not_in_classinput_prio_align = star_SJ_output_1[ !(junction %in% class_input_priority_Align$junction_compatible)]
################################################
 
  
#### now for class_input_priority_chimeric  ####
#class_input_priority_Chimeric[fileTypeR1 == "Chimeric",junction_compatible := paste(chrR1A,juncPosR1A,chrR1B,juncPosR1B,sep = ":")]
#class_input_priority_Chimeric[fileTypeR1 == "Aligned",junction_compatible := paste(chrR1A,juncPosR1A + 1,chrR1B,juncPosR1B - 1,sep = ":")]
  
#class_input_priority_Chimeric[fileTypeR1 == "Chimeric",is.STAR_Chim := 1]  #chimeric reads that are in the class input file but not in the STAR Chim.out file
#class_input_priority_Chimeric[fileTypeR1 == "Chimeric"& !(junction_compatible %in% chimeric1$junction) ,is.STAR_Chim := 0]
  
#class_input_priority_Chimeric[fileTypeR1 == "Aligned",is.STAR_SJ := 1]    #Splice junctions that are in the class input file but not in the STAR SJ.out file
#class_input_priority_Chimeric[fileTypeR1 == "Aligned"& !(junction_compatible %in% star_SJ_output_1$junction) ,is.STAR_SJ := 0]

#if ( nrow(star_fusion)>0 ) {  
# class_input_priority_Chimeric[fileTypeR1 == "Chimeric",is.STAR_Fusion := 0]  #Chimeric junctions that are in the class input file and are also called by STAR-Fusion havee is.STAR_Fusion =1 
# class_input_priority_Chimeric[fileTypeR1 == "Chimeric"& (junction_compatible %in% star_fusion$junction) ,is.STAR_Fusion := 1]
#}
#in_star_chim_not_in_classinput_prio_chim = chimeric1[!(junction%in%class_input_priority_Chimeric$junction)]
#in_star_SJ_not_in_classinput_prio_chim = star_SJ_output_1[ !(junction%in% class_input_priority_Chimeric$junction_compatible)]
###################################################
    
  
#### write output files
write.table(class_input_priority_Align,paste(directory,"class_input_WithinBAM.tsv",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
write.table(in_star_chim_not_in_classinput_prio_align,paste(directory,"in_star_chim_not_in_classinput.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
write.table(in_star_SJ_not_in_classinput_prio_align,paste(directory,"in_star_SJ_not_in_classinput.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t") 
#write.table(class_input_priority_Chimeric,paste(directory,"class_input_priorityChimeric.tsv",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
#write.table(in_star_chim_not_in_classinput_prio_chim,paste(directory,"in_star_chim_not_in_classinput_priority_Chim.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
#write.table(in_star_SJ_not_in_classinput_prio_chim,paste(directory,"in_star_SJ_not_in_classinput_priority_Chim.txt",sep = ""),quote = FALSE, row.names = FALSE, sep = "\t")
                                                                                  
