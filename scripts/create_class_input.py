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
import numpy as np
import os
import pandas as pd
import pickle
from math import ceil
import re
import sys
import time
sys.path.insert(0, '/scratch/PI/horence/JuliaO/KNIFE/circularRNApipeline_Cluster/analysis/')
import utils_os
from utils_juncReads_minimal import *

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
  return "err"

def write_class_file(junc_read_dict,out_file, single):
  fill_char = "NA"
  out = open(out_file,"w")
#   out.write("\t".join(["id", "class", "posA", "qualA", "aScoreA", "numN", 
#                        "posB", "qualB", "aScoreB", "readLen", "junction", "strandA", "strandB", "posR2A", 
#                        "qualR2A", "aScoreR2A", "numR2", "readLenR2", "junctionR2", "strandR2A", "posr2B", "qualR2B",
#                        "aScoreR2B", "strandR2B"]) + "\n")
  columns = ["id", "class", "posA", "qualA", "aScoreA", "numN", 
                       "posB", "qualB", "aScoreB", "readLen", "junction", "flagA", "flagB", "strandA", "strandB", "posR2A", 
                       "qualR2A", "aScoreR2A", "numNR2", "readLenR2", "junctionR2", "strandR2A", "posR2B", "qualR2B",
                       "aScoreR2B", "strandR2B", "fileTypeR1", "fileTypeR2", "chrA", "chrB", "geneA", "geneB", "juncPosA", "juncPosB", "readClass", "flagR2A", "flagR2B","chrR2A", "chrR2B", "geneR2A", "geneR2B", "juncPosR2A", "juncPosR2B", "readClassR2"]
  out.write("\t".join(columns) + "\n")
#  out_dict = {c : [] for c in columns}
  out_dict = {}
  for junc in junc_read_dict.keys():
    for read_name in junc_read_dict[junc].keys():
      if len(junc_read_dict[junc][read_name]) == 2:
        out_dict["id"] = read_name
#         info = [read_name]
        r1 = junc_read_dict[junc][read_name][0]
#        r2 = junc_read_dict[junc][read_name][1]
        split_ref = r1.refName.split("|")
#        print("{},{},{}".format(r1.name,r1.refName, r2.refName))
        out_dict["junction"] = r1.refName
        out_dict["numN"] = r1.numN
        out_dict["readLen"] = r1.readLen
        out_dict["posA"] = r1.offsetA
        out_dict["posB"] = r1.offsetB
        out_dict["qualA"] = r1.mapQualA
        out_dict["qualB"] = r1.mapQualB
        out_dict["aScoreA"] = r1.aScoreA
        out_dict["aScoreB"] = r1.aScoreB
        out_dict["flagA"] = r1.flagA
        out_dict["flagB"] = r1.flagB
#        try:
        out_dict["strandA"] = split_ref[0].split(":")[3]
#        except Exception as e:
#          print("split_ref", split_ref)
#          print("refName", r2.refName)
#          raise e
        out_dict["strandB"] = split_ref[1].split(":")[3]
        out_dict["chrA"] = split_ref[0].split(":")[0]
        out_dict["chrB"] = split_ref[1].split(":")[0]
        out_dict["geneA"] = split_ref[0].split(":")[1]
        out_dict["geneB"] = split_ref[1].split(":")[1]
        out_dict["juncPosA"] = split_ref[0].split(":")[2]
        out_dict["juncPosB"] = split_ref[1].split(":")[2]
        out_dict["readClass"] = split_ref[2]

        if type(r1).__name__ == "chimReadObj":
          out_dict["fileTypeR1"] = "Chimeric"
        elif type(r1).__name__ == "readObj":
          out_dict["fileTypeR1"] = "Aligned"

        if single:
          out_dict["class"] = r1.refName.split("|")[-1]
          for c in [col for col in columns if "R2" in col]:
            out_dict[c] = fill_char
        else:
          r2 = junc_read_dict[junc][read_name][1]
          read_class = get_read_class(r1, r2)
          out_dict["class"] = read_class

          if type(r2).__name__ == "chimReadObj":
            out_dict["fileTypeR2"] = "Chimeric"
          elif type(r2).__name__ == "readObj":
            out_dict["fileTypeR2"] = "Aligned"
  
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
          out_dict["numNR2"] = r2.numN
          out_dict["readLenR2"] = r2.readLen
          out_dict["junctionR2"] = r2.refName
          out_dict["posR2A"] = r2.offsetA
          out_dict["posR2B"] = r2.offsetB
          out_dict["qualR2A"] = r2.mapQualA
          out_dict["qualR2B"] = r2.mapQualB
          out_dict["aScoreR2A"] = r2.aScoreA
          out_dict["aScoreR2B"] = r2.aScoreB
          out_dict["flagR2A"] = r2.flagA
          out_dict["flagR2B"] = r2.flagB
          if len(r2.refName.split("|")) > 1:
            split_ref = r2.refName.split("|")
            out_dict["strandR2A"] = split_ref[0].split(":")[3]
            out_dict["strandR2B"] = split_ref[1].split(":")[3]
            out_dict["chrR2A"] = split_ref[0].split(":")[0]
            out_dict["chrR2B"] = split_ref[1].split(":")[0]
            out_dict["geneR2A"] = split_ref[0].split(":")[1]
            out_dict["geneR2B"] = split_ref[1].split(":")[1]
            out_dict["juncPosR2A"] = split_ref[0].split(":")[2]
            out_dict["juncPosR2B"] = split_ref[1].split(":")[2]
            out_dict["readClassR2"] = split_ref[2]
          else:
            split_ref = r2.refName.split(":")
            out_dict["strandR2A"] = split_ref[2]
            out_dict["strandR2B"] = fill_char
            out_dict["chrR2A"] = split_ref[0]
            out_dict["chrR2B"] = fill_char
            out_dict["geneR2A"] = split_ref[1]
            out_dict["geneR2B"] = fill_char
            out_dict["juncPosR2A"] = fill_char
            out_dict["juncPosR2B"] = fill_char
            out_dict["readClassR2"] = fill_char
        out.write("\t".join([str(out_dict[c]) for c in columns]) + "\n")

#         info.append(r2)
#         print("info", info)
#  df = pd.DataFrame.from_dict(out_dict)
#  df[columns].to_csv(out_file,sep="\t",index=False)
#         out.write("\t".join(info))
#         out.write("\n")
#       else:
#         print(junc_read_dict[junc][read_name])
  out.close()

   
def main():
  t0 = time.time()
  parser = argparse.ArgumentParser(description="create class input file")
  parser.add_argument("-g", "--gtf_path", help="the path to the gtf file to use for annotation")
  parser.add_argument("-a", "--assembly", help="The name of the assembly to pre-load annotation (so, mm10 for the 10th mouse assembly)")
  parser.add_argument("-i", "--input_path", help="the prefix to the STAR Aligned.out.sam and Chimeric.out.sam directory")
  parser.add_argument("-s", "--single", action="store_true", help="use this flag if the reads you are running on are single-ended")
  args = parser.parse_args()
#  gtf_data = pyensembl.Genome(reference_name='hg38', annotation_name='my_genome_features', gtf_path_or_url='/scratch/PI/horence/JuliaO/single_cell/STAR_output/mm10_files/mm10.gtf')
#  gtf_data.index()

  wrapper_path = "/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/"
  annotator_path = "{}annotators/{}.pkl".format(wrapper_path, args.assembly)
  if os.path.exists(annotator_path):
    ann = pickle.load(open("/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/annotators/{}.pkl".format(args.assembly), "rb"))
  else:
    ann = annotator.Annotator(args.gtf_path)
    pickle.dump(ann, open("/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/annotators/{}.pkl".format(args.assembly), "wb"))
  
  print("initiated annotator: {}".format(time.time() - t0))
#  gtf_file = "/scratch/PI/horence/JuliaO/single_cell/STAR_output/mm10_files/mm10.gtf"
#  ann = annotator.Annotator(gtf_file, 10000)
##  gtf_dict = get_gtf_dict(gtf_file, 10000)
#  print("loaded annotator")
  read_junc_dict = {}
  junc_read_dict = {}
  fastqIdStyle = "complete"
#  fastq_ids = ["SRR65462{}".format(x) for x in range(73,85)]
#  fastq_ids = ["SRR65462{}".format(x) for x in range(79,84)]

#  fastq_ids = ["SRR6546284"]
#  for fastq_id in fastq_ids:
#  print("{}: {}".format(fastq_id, time.time() - t0))

  samFile1 = "{}1Chimeric.out.sam".format(args.input_path)
  samFile2 = "{}1Aligned.out.sam".format(args.input_path)


  read_junc_dict, junc_read_dict = STAR_parseSam(samFile1, "r1chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)

  print("parsed r1chim", time.time() - t0)

  read_junc_dict, junc_read_dict = STAR_parseSam(samFile2, "r1align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
  print("parsed r1align", time.time() - t0)

  if not args.single:

    samFile3 = "{}2Chimeric.out.sam".format(args.input_path)
    samFile4 = "{}2Aligned.out.sam".format(args.input_path)
  
    read_junc_dict, junc_read_dict = STAR_parseSam(samFile3, "r2chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
    print("parsed r2chim", time.time() - t0)
  
    read_junc_dict, junc_read_dict = STAR_parseSam(samFile4, "r2align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
  print("parsed all", time.time() - t0)
#  write_class_file(junc_read_dict,"/scratch/PI/horence/JuliaO/single_cell/scripts/output/create_class_input/{}.tsv".format(fastq_id))
  write_class_file(junc_read_dict,"{}class_input.tsv".format(args.input_path), args.single)


#time.time() - t0

main()
