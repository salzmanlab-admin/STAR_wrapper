# Assumes preprocessAlignedReads.sh has been called and files with read ids for genome,
# junction, reg, ribo, and transcriptome alignments have been output.

# Loops through all id files to find those Rd1 ids that are aligned to a junction and not to the ribosome
# or genome. Then goes back to original sam files to get data for reads that aligned to each of these junctions
# in order to create JuncObjs with all data for the reads that aligned to a junction.

# Then assigns each read to a bucket based on where Rd1 and Rd2 aligned. Outputs reports based on analysis using the
# Naive method described in the paper into the reports directory. A very early method using a hard cutoff on alignment
# scores is still implemented here (passing alignment score thresholds for read1 as -a1 and read2 as -a2),
# but should not be used as the naive method performs better. 

import annotator
import argparse
from math import ceil
import numpy as np
import os
import pandas as pd
import pickle
#import pyensembl
import pysam
import re
import sys
import time
#sys.path.insert(0, '/scratch/PI/horence/JuliaO/KNIFE/circularRNApipeline_Cluster/analysis/')
import utils_os
from utils_juncReads_minimal import *

def get_kmer_seq_chim(cigar, seq, fileType, k, kmer_dict):
  matches = re.findall(r'(\d+)([A-Z]{1})', cigar)
  if fileType == "Aligned":
    # find the largest N (the one to split on)
    max_N_ind = None
    max_N_val = 0
#    kmer_vals = []
    for i in range(len(matches)):
        m = matches[i]
        if m[1] == "N":
            if int(m[0]) > max_N_val:
                max_N_ind = i
                max_N_val = int(m[0])    
    # get the first base of the junction
    readPos= 0
    for i in range(max_N_ind):
        m = matches[i]
        if m[1] in ["M","N","D"]:
            readPos += int(m[0])
  elif fileType == "Chimeric":
    readPos = int(matches[0][0])
  kmer_seq = seq[max(readPos - k,0):min(readPos + k,len(seq))]
  return kmer_seq

def exon1(read, exon_bounds):
  if read["chrR1A"] not in exon_bounds:
    return False
  return read["juncPosR1A"] in exon_bounds[read["chrR1A"]]

def exon2(read, exon_bounds):
  if read["chrR1B"] not in exon_bounds:
    return False
  return read["juncPosR1B"] in exon_bounds[read["chrR1B"]]

def splice_ann(read, splices):
  if read["chrR1A"] != read["chrR1B"]:
    return False
  if read["chrR1A"] not in splices:
    return False
  return tuple(sorted([read["juncPosR1A"], read["juncPosR1B"]])) in splices[read["chrR1A"]]


def get_read_fragment(posR1A, posR1B, juncPosR1A, juncPosR1B, seqR1):
  
  f1 = seqR1[:1 + int(abs(posR1A - juncPosR1A))]
  f2 = seqR1[1 + int(abs(posR1A - juncPosR1A)):]

  f1 = seqR1[:1 + int(abs(posR1B - juncPosR1B))]
  f2 = seqR1[1 + int(abs(posR1B - juncPosR1B)):]

def most_unique_kmer(k, kmer_dict, seq):
  min_val = ""
  max_val = 0
  kmer_vals = []
  for i in range(len(seq) - k + 1):
    kmer = seq[i:i + k]
    if kmer in kmer_dict:
      kmer_val = kmer_dict[kmer]
      kmer_vals.append(kmer_val)
      if min_val == "":
        min_val = kmer_val
      elif kmer_val < min_val:
        min_val = kmer_val
      if kmer_val > max_val:
        max_val = kmer_val
    else:
      kmer_vals.append(-1)
  return max_val, min_val, kmer_vals
     
    


def count_stretch(s):
  counts = {"A" : 0, "T" : 0, "C" : 0, "G" : 0, "N" : 0}
  # curr_stretch = 0
  for i in range(len(s)):
    if i == 0:
      curr_stretch = 1
    elif s[i] != s[i-1]:
      counts[s[i-1]] = max(counts[s[i-1]], curr_stretch)
      curr_stretch = 1
    else:
      curr_stretch += 1
  counts[s[-1]] = max(counts[s[-1]], curr_stretch)
  return counts


def read_strand(flag, fill_char = "NA"):
  if flag == fill_char:
    return flag
  sign_dict = {"0" : "+", "1" : "-"}
  return sign_dict['{0:012b}'.format(flag)[7]]


def entropy(kmer, c=5):
    """Calculate the entropy of a kmer using cmers as the pieces of information"""
    num_cmers = len(kmer) - c + 1
    cmers = []
    for i in range(num_cmers):
        cmers.append(kmer[i:i+c])
    Ent = 0
    for cmer in set(cmers):
#    for i in range(num_cmers):

        prob = cmers.count(cmer)/float(num_cmers)
        Ent -= prob*np.log(prob)
    return Ent

# loop through sam file, either creating a juncReadObj & juncObj (if this is read1s)
# or updating mateGenome, mateJunction, or mateRegJunction if this is an alignment file from read2
# to genome, all junctions, or regular junctions respectively.
# The sam file may contain both aligned and unaligned reads. Only aligned reads will actually be stored.
# param readType: "r1rj" is Rd1 to regular junction index, "r1j" is Rd1 to all junction,
#                 "gMate" is Rd2 to genome, "jMate" is Rd2 to all junction, "rjMate" is Rd2 to regular junction
def STAR_parseBAM(bamFile, readType, read_junc_dict, junc_read_dict, fastqIdStyle, ann, verbose = True):
    t0 = time.time()
    max_read_length = 0
    if verbose:
        print("bamFile:" + bamFile)
        print("readType:" + readType)
        
#    handle = open(samFile, "rU")
    first = False
    count = 0    
    genomic_alignments = {}
#    for line in handle:
    for bam_read in pysam.AlignmentFile(bamFile).fetch(until_eof=True):
      line = bam_read.to_string()

      # flag == 4 means the read was not mapped (not useful for us)
      if int(line.split()[1]) != 4:
        count += 1
  #      if count % 1000 == 0:
  #        print("{}: {}".format(count, time.time() - t0))
  #      if not line.startswith("@"): # ignore header lines
  #          try:

        # it's a chimeric alignment and we need another line from it
        if bam_read.has_tag("ch") and not first:
          prev_line = line
          first = True

        else:
  
          # chimeric alignment
          if bam_read.has_tag("ch"):
          
  #           print("prev_line",prev_line.strip().split())
  #           print("line",line.strip().split())
  #           print
            read = chim_newReadObj(prev_line.strip().split(), line.strip().split(), fastqIdStyle, ann)
  #           print("chim read",read)
            first = False

          # could be linear splicing or genomic
          else:
            read = newReadObj(line.strip().split(), fastqIdStyle, ann)
          test_name = "A00111:132:H3VFJDSXX:1:2123:10502:5901"
          if len(read.seqA) > max_read_length:
            max_read_length = len(read.seqA)
          if read.name == test_name:
            print("\nread", read)
  #        print("refname", read.refName)
          if readType == "r1":
            if read.name == test_name:
              print("\nread r1", read)
  
            if bam_read.has_tag("ch"):
              if read.name == test_name:
                print("\nread ch", read)
  
             
              if read.name not in read_junc_dict:
                if read.name == test_name:
                  print("\nread read_junc_dict", read)
  
                if read.refName not in junc_read_dict:
                  if read.name == test_name:
                    print("\nread junc_read_dict", read)
  
                  junc_read_dict[read.refName] = {}
                junc_read_dict[read.refName][read.name] = [read]
                read_junc_dict[read.name] = read.refName
    
            elif "|lin" in read.refName:
              if read.name == test_name:
                print("\nread lin", read)
  
  #            if "|lin" in read.refName:
              if read.name not in read_junc_dict:
                if read.name == test_name:
                  print("\nread lin read_junc_dict", read)
  
                if read.refName not in junc_read_dict:
                  if read.name == test_name:
                    print("\nread lin junc_read_dict", read)
  
                  junc_read_dict[read.refName] = {}
                junc_read_dict[read.refName][read.name] = [read]
                read_junc_dict[read.name] = read.refName
            else:
#              genomic_alignments.add(read.name)
              if read.name not in genomic_alignments:
                genomic_alignments[read.name] = float(read.aScoreA)
              else:
                genomic_alignments[read.name] = max(float(read.aScoreA),genomic_alignments[read.name])
  
  #        if readType == "r1chim":
  #          if read.refName not in junc_read_dict.keys():
  #            junc_read_dict[read.refName] = {}
  #          junc_read_dict[read.refName][read.name] = [read]
  #          read_junc_dict[read.name] = read.refName
  ##        elif readType == "r1align":
  ##          if read.name not in read_junc_dict.keys():
  #        elif readType == "r1align":
  #          if read.refName not in junc_read_dict.keys():
  #            junc_read_dict[read.refName] = {}
  #          junc_read_dict[read.refName][read.name] = [read]
  #          read_junc_dict[read
              
          # add mates 
          elif readType == "r2":
            if read.name in read_junc_dict:
              if read.name == test_name:
                print("\nread r2", read)
  
              junc_read_dict[read_junc_dict[read.name]][read.name].append(read)
              
              assert len(junc_read_dict[read_junc_dict[read.name]][read.name]) == 2
              del read_junc_dict[read.name]
  
  #       xcept Exception as e:
  #          print("Exception")
  #          print(e)
  #          print("error:", sys.exc_info()[0])
  #          print("parsing sam output for", line)
  #          
  #    handle.close()
    return read_junc_dict, junc_read_dict, genomic_alignments, max_read_length


# loop through sam file, either creating a juncReadObj & juncObj (if this is read1s)
# or updating mateGenome, mateJunction, or mateRegJunction if this is an alignment file from read2
# to genome, all junctions, or regular junctions respectively.
# The sam file may contain both aligned and unaligned reads. Only aligned reads will actually be stored.
# param readType: "r1rj" is Rd1 to regular junction index, "r1j" is Rd1 to all junction,
#                 "gMate" is Rd2 to genome, "jMate" is Rd2 to all junction, "rjMate" is Rd2 to regular junction
def STAR_parseSam(samFile, readType, read_junc_dict, junc_read_dict, fastqIdStyle, ann, verbose = True):
    t0 = time.time()
    if verbose:
        print("samFile:" + samFile)
        print("readType:" + readType)
        
    handle = open(samFile, "rU")
    first = False
    count = 0    
    for line in handle:
        count += 1
#        if count % 1000 == 0:
#          print("{}: {}".format(count, time.time() - t0))
        if not line.startswith("@"): # ignore header lines
          # don't want to include unmapped reads
          if int(line.split()[1]) != 4:
#            try:
                if "chim" in readType and not first:
                  prev_line = line
                  first = True
                else:

                  if "chim" in readType:
                  
#                     print("prev_line",prev_line.strip().split())
#                     print("line",line.strip().split())
#                     print
                    read = chim_newReadObj(prev_line.strip().split(), line.strip().split(), fastqIdStyle, ann)
#                     print("chim read",read)
                    first = False
                  else:
                    read = newReadObj(line.strip().split(), fastqIdStyle, ann)
#                  print("refname", read.refName)
                  if readType == "r1chim":
                   
                    if read.name not in read_junc_dict:
                      if read.refName not in junc_read_dict:
                        junc_read_dict[read.refName] = {}
                      junc_read_dict[read.refName][read.name] = [read]
                      read_junc_dict[read.name] = read.refName

                  if readType == "r1align":
                    if "|lin" in read.refName:
                      if read.name not in read_junc_dict:
                        if read.refName not in junc_read_dict:
                          junc_read_dict[read.refName] = {}
                        junc_read_dict[read.refName][read.name] = [read]
                        read_junc_dict[read.name] = read.refName

#                  if readType == "r1chim":
#                    if read.refName not in junc_read_dict.keys():
#                      junc_read_dict[read.refName] = {}
#                    junc_read_dict[read.refName][read.name] = [read]
#                    read_junc_dict[read.name] = read.refName
##                  elif readType == "r1align":
##                    if read.name not in read_junc_dict.keys():
#                  elif readType == "r1align":
#                    if read.refName not in junc_read_dict.keys():
#                      junc_read_dict[read.refName] = {}
#                    junc_read_dict[read.refName][read.name] = [read]
#                    read_junc_dict[read
                      
                  # add mates 
                  elif "r2" in readType:
                    if read.name in read_junc_dict:
                      junc_read_dict[read_junc_dict[read.name]][read.name].append(read)
                      
                      assert len(junc_read_dict[read_junc_dict[read.name]][read.name]) == 2
                      del read_junc_dict[read.name]

#            except Exception as e:
#                print("Exception")
#                print(e)
#                print("error:", sys.exc_info()[0])
#                print("parsing sam output for", line)
#                
    handle.close()
    return read_junc_dict, junc_read_dict

def get_loc_flag(r1, r2):
  if "|fus" in r1.refName:
    return 1
  if "|sc" in r1.refName:
    return 0
  r_strand = read_strand(r1.flagA)
  if "|lin" in r1.refName:
    if r_strand == "+":
      if int(r2.offsetA) > int(r1.offsetA):
        return 1
      else:
        return 0
    if r_strand == "-":
      if int(r2.offsetA) < int(r1.offsetA):
        return 1
      else:
        return 0
  if "|rev" in r1.refName:
    if (int(r1.offsetA) <= int(r2.offsetA) <= int(r1.offsetB)) or (int(r1.offsetB) <= int(r2.offsetA) <= int(r1.offsetA)):
      return 1
    else:
      return 0
  return "error"

def get_read_class(r1, r2):
  if "|lin" in r1.refName:
    return "linear"
  vals = r1.refName.split("|")
  if "|fus" in r2.refName:
    return "fusion"
  if "|sc" in r1.refName:
    return "strandCross"
  r2chr = r2.refName.split("|")[0].split(":")[0]
    
#   print("r2chr", r2chr)
  if ("|fus" in r1.refName) or (vals[0].split(":")[0] != r2chr):
    return "fusion"
  if "|rev" in r1.refName:
    offset1 = int(vals[0].split(":")[2])
    offset2 = int(vals[1].split(":")[2])
    strand = vals[0].split(":")[-1]
    if type(r2).__name__ == "chimReadObj":
      if strand == "+":
        if (offset2 <= int(r2.offsetA) <= offset1) and (offset2 <= int(r2.offsetB) <= offset1):
          return "circular"
        else:
          return "decoy"
      elif strand == "-":
         if (offset2 >= int(r2.offsetA) >= offset1) and (offset2 >= int(r2.offsetB) >= offset1):
           return "circular"
         else:
           return "decoy"
      
#        if ((offset1 <= int(r2.offsetA) <= offset2) and (offset1 <= int(r2.offsetB) <= offset2)) or ((offset2 <= int(r2.offsetA) <= offset1) and (offset2 <= int(r2.offsetB) <= offset1)):
#          return "circular" 
#        else:
#          return "decoy"
    else:
#      print("offset1",offset1)
#      print("offset2",offset2)
#      print("r2.offset",r2.offset)
      if strand == "+":
        if (offset2 <= int(r2.offsetA) <= offset1):
          return "circular"
        else:
          return "decoy"
      elif strand == "-":
         if (offset2 >= int(r2.offsetA) >= offset1):
           return "circular"
         else:
           return "decoy"

#      if (offset1 <= int(r2.offsetA) <= offset2) or (offset2 <= int(r2.offsetA) <= offset1):
#        return "circular"
#      else:
#        return "decoy"
  return "error"

def get_SM(cigar):
  matches = re.findall(r'(\d+)([A-Z]{1})', cigar)
  M = 0
  S = 0
  I = 0
  D = 0
  for m in matches:
    if m[1] == "M":
      M += int(m[0])
    elif m[1] == "S":
      S += int(m[0])
    elif m[1] == "I":
      I += int(m[0])
    elif m[1] == "D":
      D += int(m[0])

  return M, S, I, D

def write_class_file(junc_read_dict,out_file, single, genomic_alignments, tenX, include_one_read, max_read_length):
  k = 14
  splices = pickle.load(open("/oak/stanford/groups/horence/JuliaO/pickled/grch38_juncs.pkl","rb"))
  kmer_dict = pickle.load(open("/oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/kmer_dict_{}.pkl".format(k),"rb"))
  exon_bounds = pickle.load(open("/oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_exon_bounds_all.pkl","rb"))
  fill_char = "NA"
  #meta_df =  pd.read_csv("/oak/stanford/groups/horence/Roozbeh/single_cell_project/utility_files/TS_Pilot_Smartseq_metadata.csv") 
#  plate = out_file.split("/")[-2].split("_")[0]
#  if plate in list(meta_df["Plate ID"]): 
#    organ = meta_df[meta_df["Plate ID"] == plate].iloc[0]["Organ"]
#    cell_type = "".join(meta_df[meta_df["Plate ID"] == plate].iloc[0]["Cell Type(s)"].split())
#  else:
  organ = fill_char
  cell_type = fill_char

  if include_one_read:
    out = open(".".join(out_file.split(".")[:-1]) + "_inc." + out_file.split(".")[-1],"w")
  else:
    out = open(out_file,"w")

 

#   out.write("\t".join(["id", "class", "posA", "qualA", "aScoreA", "numN", 
#                        "posB", "qualB", "aScoreB", "readLen", "junction", "strandA", "strandB", "posR2A", 
#                        "qualR2A", "aScoreR2A", "numR2", "readLenR2", "junctionR2", "strandR2A", "posr2B", "qualR2B",
#                        "aScoreR2B", "strandR2B"]) + "\n")
#  columns = ["id", "class", "posR1A", "qualR1A", "aScoreR1A", "numNR1", 
#                       "posR1B", "qualR1B", "aScoreR1B", "readLenR1", "refNameR1", "flagR1A", "flagR1B", "strandR1A", "strandR1B", "posR2R1A", 
#                       "qualR2A", "aScoreR2A", "numNR2", "readLenR2", "refNameR2", "strandR2A", "posR2B", "qualR2B",
#                       "aScoreR2B", "strandR2B", "fileTypeR1", "fileTypeR2", "chrR1A", "chrR1B", "geneR1A", "geneR1B", "juncPosR1A", "juncPosR1B", "readClassR1", "flagR2A", "flagR2B","chrR2A", "chrR2B", "geneR2A", "geneR2B", "juncPosR2A", "juncPosR2B", "readClassR2"]
  columns = ['id', 'class', 'refName_ABR1', 'refName_readStrandR1','refName_ABR2', 'refName_readStrandR2', 'fileTypeR1', 'fileTypeR2', 'readClassR1', 'readClassR2','numNR1', 'numNR2', 'readLenR1', 'readLenR2', 'barcode', 'UMI', 'entropyR1', 'entropyR2', 'seqR1', 'seqR2', "read_strand_compatible", "location_compatible", "strand_crossR1", "strand_crossR2", "genomicAlignmentR1", "spliceDist", "AT_run_R1", "GC_run_R1", "max_run_R1", "AT_run_R2", "GC_run_R2", "max_run_R2", "Organ", "Cell_Type(s)", "min_junc_{}mer".format(k), "max_junc_{}mer".format(k), "splice_ann", "exon_annR1A", "exon_annR1B", "both_ann", "genomic_aScoreR1"]

  for i in range(max_read_length - k + 1):
    columns.append("kmer_map_{}".format(i))
  col_base = ['chr','gene', 'juncPos', 'gene_strand', 'aScore', 'flag', 'pos', 'qual', "MD", 'nmm', 'cigar', 'M','S',
              'NH', 'HI', 'nM', 'NM', 'jM', 'jI', 'read_strand']
  for c in col_base:
    for r in ["R1","R2"]:
      for l in ["A","B"]:
        columns.append("{}{}{}".format(c,r,l))
#  columns = ['id', 'class', 'refNameR1', 'refNameR2', 'fileTypeR1', 'fileTypeR2', 
#             'chrR1A', 'chrR1B', 'chrR2A', 'chrR2B', 'geneR1A', 'geneR1B', 'geneR2A', 'geneR2B', 
#             'juncPosR1A', 'juncPosR1B', 'juncPosR2A', 'juncPosR2B', 
#             'strandR1A', 'strandR1B', 'strandR2A', 'strandR2B', 'readClassR1', 'readClassR2', 
#             'aScoreR1A', 'aScoreR1B', 'aScoreR2A', 'aScoreR2B', 'flagR1A', 'flagR1B', 'flagR2A', 'flagR2B', 
#             'numNR1', 'numNR2', 'posR1A', 'posR1B', 'posR2A', 'posR2B', 
#             'qualR1A', 'qualR1B', 'qualR2A', 'qualR2B', 'readLenR1', 'readLenR2', "MDR1A", "MDR1B", "MDR2A", "MDR2B", 
#             'nmmR1A', 'nmmR1B', 'nmmR2A', 'nmmR2B', 'cigarR1A', 'cigarR1B','cigarR2A','cigarR2B', 'MR1A', 'MR1B','MR2A','MR2B',]
  out.write("\t".join(columns) + "\n")
#  out_dict = {c : [] for c in columns}
  write_count = 0
  out_dict = {}
  for junc in junc_read_dict.keys():
    for read_name in junc_read_dict[junc].keys():
      one_read = (len(junc_read_dict[junc][read_name]) == 1 and include_one_read)
      if (len(junc_read_dict[junc][read_name]) == 2 and not single) or (len(junc_read_dict[junc][read_name]) == 1 and single) or one_read:
        out_dict["id"] = read_name
        out_dict["Organ"] = organ
        out_dict["Cell_Type(s)"] = cell_type
        if read_name in genomic_alignments:
          out_dict["genomicAlignmentR1"] = 1
          out_dict["genomic_aScoreR1"] = genomic_alignments[read_name]
        else:
          out_dict["genomicAlignmentR1"] = 0
          out_dict["genomic_aScoreR1"] = fill_char
        if tenX:
          read_vals = read_name.split("_")
          out_dict["barcode"] = read_vals[-2]
          out_dict["UMI"] = read_vals[-1]
        else:
          out_dict["barcode"] = fill_char
          out_dict["UMI"] = fill_char
        if single or one_read:
          out_dict["read_strand_compatible"] = fill_char
          out_dict["location_compatible"] = fill_char

#         info = [read_name]
        r1 = junc_read_dict[junc][read_name][0]
#        r2 = junc_read_dict[junc][read_name][1]
        split_ref = r1.refName.split("|")
#        print("{},{},{}".format(r1.name,r1.refName, r2.refName))
        out_dict["refName_ABR1"] = r1.refName_AB
        out_dict["refName_readStrandR1"] = r1.refName_readStrand
        counts = count_stretch(r1.seqA)
        out_dict["AT_run_R1"] = max(counts["A"], counts["T"])
        out_dict["GC_run_R1"] = max(counts["G"], counts["C"])
        out_dict["max_run_R1"] = max(counts.values())
        out_dict["numNR1"] = r1.numN
        out_dict["readLenR1"] = r1.readLen
        out_dict["posR1A"] = r1.offsetA
        out_dict["posR1B"] = r1.offsetB
        out_dict["qualR1A"] = r1.mapQualA
        out_dict["qualR1B"] = r1.mapQualB
        out_dict["aScoreR1A"] = r1.aScoreA
        out_dict["aScoreR1B"] = r1.aScoreB
        out_dict["flagR1A"] = r1.flagA
        out_dict["flagR1B"] = r1.flagB
#        try:
        out_dict["gene_strandR1A"] = split_ref[0].split(":")[3]
        out_dict["read_strandR1A"] = read_strand(r1.flagA)
#        except Exception as e:
#          print("split_ref", split_ref)
#          print("refName", r2.refName)
#          raise e
        out_dict["gene_strandR1B"] = split_ref[1].split(":")[3]
        out_dict["read_strandR1B"] = read_strand(r1.flagB)
    
        out_dict["chrR1A"] = split_ref[0].split(":")[0]
        out_dict["chrR1B"] = split_ref[1].split(":")[0]
        out_dict["geneR1A"] = split_ref[0].split(":")[1]
        out_dict["geneR1B"] = split_ref[1].split(":")[1]
        out_dict["juncPosR1A"] = split_ref[0].split(":")[2]
        out_dict["juncPosR1B"] = split_ref[1].split(":")[2]
        out_dict["readClassR1"] = split_ref[2]
        out_dict["splice_ann"] = splice_ann(out_dict, splices)
        out_dict["exon_annR1A"] = exon1(out_dict, exon_bounds)
        out_dict["exon_annR1B"] = exon2(out_dict, exon_bounds)
        out_dict["both_ann"] = out_dict["exon_annR1A"] & out_dict["exon_annR1B"]

        if out_dict["readClassR1"] == "fus":
          out_dict["spliceDist"] = "NA"
        else:
          out_dict["spliceDist"] = abs(int(out_dict["juncPosR1A"]) - int(out_dict["juncPosR1B"]))
        out_dict["MDR1A"] = r1.MDA
        out_dict["MDR1B"] = r1.MDB
        out_dict["nmmR1A"] = r1.nmmA
        out_dict["nmmR1B"] = r1.nmmB
        out_dict["cigarR1A"] = r1.cigarA
        out_dict["cigarR1B"] = r1.cigarB
        M, S, I, D = get_SM(r1.cigarA)
        out_dict["MR1A"] = M
        out_dict["SR1A"] = S
        out_dict["IR1A"] = I
        out_dict["DR1A"] = D

        M, S, I, D = get_SM(r1.cigarB)
        out_dict["MR1B"] = M
        out_dict["SR1B"] = S
        out_dict["IR1B"] = I
        out_dict["DR1B"] = D

        out_dict["NHR1A"] = r1.NHA
        out_dict["NHR1B"] = r1.NHB
        out_dict["HIR1A"] = r1.HIA
        out_dict["HIR1B"] = r1.HIB
        out_dict["nMR1A"] = r1.nMA
        out_dict["nMR1B"] = r1.nMB
        out_dict["NMR1A"] = r1.NMA
        out_dict["NMR1B"] = r1.NMB
        out_dict["jMR1A"] = r1.jMA
        out_dict["jMR1B"] = r1.jMB
        out_dict["jIR1A"] = r1.jIA
        out_dict["jIR1B"] = r1.jIB
        out_dict["seqR1"] = r1.seqA
        out_dict["entropyR1"] = entropy(r1.seqA)
#        out_dict["seqR1B"] = r1.seqB

        if type(r1).__name__ == "chimReadObj":
          out_dict["fileTypeR1"] = "Chimeric"
          
          if out_dict["read_strandR1A"] != out_dict["read_strandR1B"]:
            out_dict["strand_crossR1"] = 1
          else:
            out_dict["strand_crossR1"] = 0
         
          
        elif type(r1).__name__ == "readObj":
          out_dict["fileTypeR1"] = "Aligned"
          out_dict["strand_crossR1"] = 0

        kmer_seq = get_kmer_seq_chim(r1.cigar, r1.seqA, out_dict["fileTypeR1"], k, kmer_dict)
        max_val, min_val, kmer_vals = most_unique_kmer(k, kmer_dict, kmer_seq)
        
        out_dict["min_junc_{}mer".format(k)] = min_val
        out_dict["max_junc_{}mer".format(k)] = max_val
        for i in range(max_read_length - k + 1):
          try:
            out_dict["kmer_map_{}".format(i)] = kmer_vals[i]
          except:
            out_dict["kmer_map_{}".format(i)] = fill_char


        if single or one_read:
          out_dict["class"] = r1.refName.split("|")[-1]
          for c in [col for col in columns if "R2" in col]:
            out_dict[c] = fill_char
        else:
          r2 = junc_read_dict[junc][read_name][1]
          read_class = get_read_class(r1, r2)
          out_dict["class"] = read_class
          out_dict["location_compatible"] = get_loc_flag(r1, r2)

          if type(r2).__name__ == "chimReadObj":
            out_dict["fileTypeR2"] = "Chimeric"
            if out_dict["read_strandR2A"] != out_dict["read_strandR2B"]:
              out_dict["strand_crossR2"] = 1
            else:
              out_dict["strand_crossR2"] = 0


          elif type(r2).__name__ == "readObj":
            out_dict["fileTypeR2"] = "Aligned"
            out_dict["strand_crossR2"] = 0
 
  #         info.append(read_class)
  #         info.append(r1.offsetA)
  #         info.append(r1.mapQualA)
  #         info.append(r1.aScoreA)
  #         info.append(str(r1.numN))
  #         info.append(r1.offsetB)
  #         info.append(r1.mapQualB)
  #         info.append(r1.aScoreB)
  #         info.append(str(r1.readLen))
  #         info.append(r1.refName)
  #         info.append(str(r1.flagA))
  #         info.append(str(r1.flagB))
          out_dict["seqR2"] = r2.seqA
          out_dict["entropyR2"] = entropy(r2.seqA)
#          out_dict["seqR2B"] = r2.seqB
          out_dict["numNR2"] = r2.numN
          out_dict["readLenR2"] = r2.readLen
          out_dict["refName_ABR2"] = r2.refName_AB
          out_dict["refName_readStrandR2"] = r2.refName_readStrand
          counts = count_stretch(r2.seqA)
          out_dict["AT_run_R2"] = max(counts["A"], counts["T"])
          out_dict["GC_run_R2"] = max(counts["G"], counts["C"])
          out_dict["max_run_R2"] = max(counts.values())

          out_dict["posR2A"] = r2.offsetA
          out_dict["posR2B"] = r2.offsetB
          out_dict["qualR2A"] = r2.mapQualA
          out_dict["qualR2B"] = r2.mapQualB
          out_dict["aScoreR2A"] = r2.aScoreA
          out_dict["aScoreR2B"] = r2.aScoreB
          out_dict["flagR2A"] = r2.flagA
          out_dict["flagR2B"] = r2.flagB
          out_dict["MDR2A"] = r2.MDA
          out_dict["MDR2B"] = r2.MDB
          out_dict["nmmR2A"] = r2.nmmA
          out_dict["nmmR2B"] = r2.nmmB
          out_dict["cigarR2A"] = r2.cigarA
          out_dict["cigarR2B"] = r2.cigarB
          M, S, I, D = get_SM(r2.cigarA)
          out_dict["MR2A"] = M
          out_dict["SR2A"] = S
          out_dict["IR2A"] = I
          out_dict["DR2A"] = D

          out_dict["NHR2A"] = r2.NHA
          out_dict["NHR2B"] = r2.NHB
          out_dict["HIR2A"] = r2.HIA
          out_dict["HIR2B"] = r2.HIB
          out_dict["nMR2A"] = r2.nMA
          out_dict["nMR2B"] = r2.nMB
          out_dict["NMR2A"] = r2.NMA
          out_dict["NMR2B"] = r2.NMB
          out_dict["jMR2A"] = r2.jMA
          out_dict["jMR2B"] = r2.jMB
          out_dict["jIR2A"] = r2.jIA
          out_dict["jIR2B"] = r2.jIB
          out_dict["read_strandR2A"] = read_strand(r2.flagA)
          out_dict["read_strandR2B"] = read_strand(r2.flagB)



          if len(r2.refName.split("|")) > 1:
            split_ref = r2.refName.split("|")
            out_dict["gene_strandR2A"] = split_ref[0].split(":")[3]
            out_dict["gene_strandR2B"] = split_ref[1].split(":")[3]


            out_dict["chrR2A"] = split_ref[0].split(":")[0]
            out_dict["chrR2B"] = split_ref[1].split(":")[0]
            out_dict["geneR2A"] = split_ref[0].split(":")[1]
            out_dict["geneR2B"] = split_ref[1].split(":")[1]
            out_dict["juncPosR2A"] = split_ref[0].split(":")[2]
            out_dict["juncPosR2B"] = split_ref[1].split(":")[2]
            out_dict["readClassR2"] = split_ref[2]
            M, S, I, D = get_SM(r2.cigarB)
            out_dict["MR2B"] = M
            out_dict["SR2B"] = S
            out_dict["IR2B"] = I
            out_dict["DR2B"] = D


            if out_dict["read_strandR1A"] == out_dict["read_strandR2A"]:
              out_dict["read_strand_compatible"] = 0
            elif out_dict["read_strandR1A"] != out_dict["read_strandR2A"]:
              out_dict["read_strand_compatible"] = 1


          else:
            split_ref = r2.refName.split(":")
            out_dict["gene_strandR2A"] = split_ref[2]
            out_dict["gene_strandR2B"] = fill_char
            out_dict["chrR2A"] = split_ref[0]
            out_dict["chrR2B"] = fill_char
            out_dict["geneR2A"] = split_ref[1]
            out_dict["geneR2B"] = fill_char
            out_dict["juncPosR2A"] = fill_char
            out_dict["juncPosR2B"] = fill_char
            out_dict["readClassR2"] = fill_char
            out_dict["MR2B"] = fill_char
            out_dict["SR2B"] = fill_char
            if out_dict["read_strandR1A"] == out_dict["read_strandR2A"]:
              out_dict["read_strand_compatible"] = 0
            elif out_dict["read_strandR1A"] != out_dict["read_strandR2A"]:
              out_dict["read_strand_compatible"] = 1

        out.write("\t".join([str(out_dict[c]) for c in columns]) + "\n")
        write_count += 1

#         info.append(r2)
#         print("info", info)
#  df = pd.DataFrame.from_dict(out_dict)
#  df[columns].to_csv(out_file,sep="\t",index=False)
#         out.write("\t".join(info))
#         out.write("\n")
#       else:
#         print(junc_read_dict[junc][read_name])
  out.close()
  print("write count", write_count)

   
def main():
  t0 = time.time()
  parser = argparse.ArgumentParser(description="create class input file")
  parser.add_argument("-g", "--gtf_path", help="the path to the gtf file to use for annotation")
  parser.add_argument("-a", "--assembly", help="The name of the assembly to pre-load annotation (so, mm10 for the 10th mouse assembly)")
  parser.add_argument("-i", "--input_path", help="the prefix to the STAR Aligned.out.sam and Chimeric.out.sam directory")
  parser.add_argument("-I", "--input_file",help="specify file name of different format",default="")
  parser.add_argument("-s", "--single", action="store_true", help="use this flag if the reads you are running on are single-ended")
  parser.add_argument("-t", "--tenX", action="store_true", help="indicate whether this is 10X data (with UMIs and barcodes)")
  parser.add_argument("-T", "--test", action="store_true", help="save dictionaries and don't write class input")
  parser.add_argument("-n", "--include_one_read", action="store_true",help="also save reads where only r1 maps")
#  include_one_read = True


  args = parser.parse_args()
#  gtf_data = pyensembl.Genome(reference_name='hg38', annotation_name='my_genome_features', gtf_path_or_url='/scratch/PI/horence/JuliaO/single_cell/STAR_output/mm10_files/mm10.gtf')
#  gtf_data.index()

  wrapper_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/"
#  annotator_path = "{}annotators/pyensembl_{}.pkl".format(wrapper_path, args.assembly)
  annotator_path = "{}annotators/{}.pkl".format(wrapper_path, args.assembly)

  if os.path.exists(annotator_path):
    ann = pickle.load(open(annotator_path, "rb"))
  else:
    ann = annotator.Annotator(args.gtf_path)
#    ann = pyensembl.Genome(reference_name = args.assembly,
#             annotation_name = "my_genome_features",
#             gtf_path_or_url=args.gtf_path)
#    ann.index()

    pickle.dump(ann, open(annotator_path, "wb"))
  fastqIdStyle = "complete" 

  print("initiated annotator: {}".format(time.time() - t0))
#  gtf_file = "/scratch/PI/horence/JuliaO/single_cell/STAR_output/mm10_files/mm10.gtf"
#  ann = annotator.Annotator(gtf_file, 10000)
##  gtf_dict = get_gtf_dict(gtf_file, 10000)
#  print("loaded annotator")
#  regimes = ["priorityAlign", "priorityChimeric"]
#  for regime in regimes:
  read_junc_dict = {}
  junc_read_dict = {}

#  fastq_ids = ["SRR65462{}".format(x) for x in range(73,85)]
#  fastq_ids = ["SRR65462{}".format(x) for x in range(79,84)]

#  fastq_ids = ["SRR6546284"]
#  for fastq_id in fastq_ids:
#  print("{}: {}".format(fastq_id, time.time() - t0))

#  if args.single:
#    samFile1 = "{}2Chimeric.out.sam".format(args.input_path)
#    samFile2 = "{}2Aligned.out.sam".format(args.input_path)

#  else:
#    samFile1 = "{}1Chimeric.out.sam".format(args.input_path)
#    samFile2 = "{}1Aligned.out.sam".format(args.input_path)
#    samFile3 = "{}2Chimeric.out.sam".format(args.input_path)
#    samFile4 = "{}2Aligned.out.sam".format(args.input_path)
  
  if args.input_file != "":
    bamFile1 = args.input_file
  elif args.single:
    bamFile1 = "{}3Aligned.out.bam".format(args.input_path)
  else:
    bamFile1 = "{}1Aligned.out.bam".format(args.input_path)
    bamFile2 = "{}2Aligned.out.bam".format(args.input_path)


  if args.single:
    read_junc_dict, junc_read_dict, genomic_alignments, max_read_length = STAR_parseBAM(bamFile1, "r1", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
  else:
    read_junc_dict, junc_read_dict, genomic_alignments, max_read_length = STAR_parseBAM(bamFile1, "r1", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
    read_junc_dict, junc_read_dict, _, _ = STAR_parseBAM(bamFile2, "r2", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
  print("len junc_read_dict",len(junc_read_dict))
  

 # if regime == "priorityAlign":
 #   read_junc_dict, junc_read_dict = STAR_parseSam(samFile2, "r1align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
 #   print("parsed r1align", time.time() - t0)
#    read_junc_dict, junc_read_dict = STAR_parseSam(samFile1, "r1chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
#    print("parsed r1chim", time.time() - t0)
#  elif regime == "priorityChimeric":
#    read_junc_dict, junc_read_dict = STAR_parseSam(samFile1, "r1chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
#    print("parsed r1chim", time.time() - t0)
#    read_junc_dict, junc_read_dict = STAR_parseSam(samFile2, "r1align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
#    print("parsed r1align", time.time() - t0)
#  if not args.single:
#    if regime == "priorityAlign":
#       read_junc_dict, junc_read_dict = STAR_parseSam(samFile4, "r2align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
#       print("parsed r2align", time.time() - t0)
#       read_junc_dict, junc_read_dict = STAR_parseSam(samFile3, "r2chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
#       print("parsed r2chim", time.time() - t0)
#    elif regime == "priorityChimeric":  
#       read_junc_dict, junc_read_dict = STAR_parseSam(samFile3, "r2chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
#       print("parsed r2chim", time.time() - t0)
#       read_junc_dict, junc_read_dict = STAR_parseSam(samFile4, "r2align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
#       print("parsed r2align", time.time() - t0)
#  print("len(junc_read_dict)", len(junc_read_dict))

#  print("parsed all {}".format(regime), time.time() - t0)
#  write_class_file(junc_read_dict,"/scratch/PI/horence/JuliaO/single_cell/scripts/output/create_class_input/{}.tsv".format(fastq_id))
  if args.test:
    pickle.dump(read_junc_dict, open("{}read_junc_dict.pkl".format(args.input_path), "wb"))
    pickle.dump(junc_read_dict, open("{}junc_read_dict.pkl".format(args.input_path), "wb"))
  else:
    write_class_file(junc_read_dict,"{}class_input_{}_test.tsv".format(args.input_path, "WithinBAM"), args.single, genomic_alignments, args.tenX, args.include_one_read, max_read_length)
#    print("genomic alignments",genomic_alignments)
#
#time.time() - t0

main()
