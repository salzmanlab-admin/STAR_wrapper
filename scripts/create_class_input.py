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
            try:
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
                    if "lin" in read.refName:
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
#                   elif readType == "r2align":
#                     if read.name in read_junc_dict.keys():
#                       junc_read_dict[read_junc_dict[read.name]][read.name].append(read)
#                       assert len(junc_read_dict[read_junc_dict[read.name]][read.name]) == 2
# #                     print("split read", line.strip().split())
# #                     print(read)
#                   # only need to store info if the read actually aligned 
#                   # only need to store info if the read actually aligned 
                  
#                   if read.aScore:
#                       readSubType = get_readSubType(readType, read.refName)
# #                       print("readSubType",readSubType)
#                       readBase = read.baseName  # part of the read that is the same between Rd1 and Rd2
#                       # read1 that didn't map to genome, or ribo and then mapped to reg junctions or to all junctions and not to reg junction
#                       # since in unaligned mode we report all reads, we want to only count the first time in the file we see it (output order is highest alignment score first)
#                       if ((readSubType == "r1j" and readBase not in juncReads) or
#                           (readSubType == "r1rj"  and readBase not in juncReads)):
#                           curJuncReadObj = juncReadObj(read)  # create object for this read (mate info empty for now) to put in junction and juncReads dicts
#                           juncReads[readBase] = curJuncReadObj  # will look up this obj later to populate mates

#                           # this is first read aligning to this junction, need to create juncObj first
#                           if not read.refName in junctions:
#                               curJuncObj = juncObj(read.refName)
#                               junctions[read.refName] = curJuncObj
#                           # initially just append all reads to unknownReads, we will later remove some and move to circularReads, decoyReads, or unmappedReads
#                           junctions[read.refName].unknownReads.append(curJuncReadObj)
#                       elif readBase in juncReads: # this is a mate so we only care about it if it's Rd1 was stored
#                           if readSubType == "gMate" and not juncReads[readBase].mateGenomic:  # only if we haven't already found the primary genomic alignment
#                               juncReads[readBase].mateGenomic = read
#                           else:
#                               # this is a junction mate, need to check offset 
#                               if (int(read.offset) >= (JUNC_MIDPOINT - int(read.readLen) + overhang + 1) and
#                                   int(read.offset) <= (JUNC_MIDPOINT - overhang + 1)):
#                                   # if it overlaps the junction, add it to the appropriate mate field
#                                   if readSubType == "jMate" and not juncReads[readBase].mateJunction:  # only if we haven't already found the primary junction alignment
#                                       juncReads[readBase].mateJunction = read
#                                   elif readSubType == "rjMate" and not juncReads[readBase].mateRegJunction:  # only if we haven't already found the primary reg junction alignment
#                                       juncReads[readBase].mateRegJunction = read
# #                                   elif readType == "dMate" and not juncReads[readBase].mateDenovoJunction:  # only if we haven't already found the primary denovo junction alignment
# #                                       juncReads[readBase].mateDenovoJunction = read
            except Exception as e:
                print("Exception")
                print(e)
                print("error:", sys.exc_info()[0])
                print("parsing sam output for", line)
                
    handle.close()
    return read_junc_dict, junc_read_dict

def get_read_class(r1, r2):
  if "lin" in r1.refName:
    return "linear"
  vals = r1.refName.split("|")
  if "|" in r2.refName:
    if "fus" in r2.refName:
      return "fusion"
  r2chr = r2.refName.split("|")[0].split(":")[0]
    
#   print("r2chr", r2chr)
  if ("fus" in r1.refName) or (vals[0].split(":")[0] != r2chr):
    return "fusion"
  if "rev" in r1.refName:
    offset1 = int(vals[0].split(":")[2])
    offset2 = int(vals[1].split(":")[2])
    if type(r2).__name__ == "chimReadObj":
      if ((offset1 <= int(r2.offsetA) <= offset2) and (offset1 <= int(r2.offsetB) <= offset2)) or ((offset2 <= int(r2.offsetA) <= offset1) and (offset2 <= int(r2.offsetB) <= offset1)):
        return "circular" 
      else:
        return "decoy"
    else:
#      print("offset1",offset1)
#      print("offset2",offset2)
#      print("r2.offset",r2.offset)
      if (offset1 <= int(r2.offsetA) <= offset2) or (offset2 <= int(r2.offsetA) <= offset1):
        return "circular"
      else:
        return "decoy"
  return "err"

def write_class_file(junc_read_dict,out_file):
#   out = open(out_file,"w")
#   out.write("\t".join(["id", "class", "posA", "qualA", "aScoreA", "numN", 
#                        "posB", "qualB", "aScoreB", "readLen", "junction", "strandA", "strandB", "posR2A", 
#                        "qualR2A", "aScoreR2A", "numR2", "readLenR2", "junctionR2", "strandR2A", "posr2B", "qualR2B",
#                        "aScoreR2B", "strandR2B"]) + "\n")
  columns = ["id", "class", "posA", "qualA", "aScoreA", "numN", 
                       "posB", "qualB", "aScoreB", "readLen", "junction", "strandA", "strandB", "posR2A", 
                       "qualR2A", "aScoreR2A", "numNR2", "readLenR2", "junctionR2", "strandR2A", "posR2B", "qualR2B",
                       "aScoreR2B", "strandR2B", "fileTypeR1", "fileTypeR2"]
  out_dict = {c : [] for c in columns}
  for junc in junc_read_dict.keys():
    for read_name in junc_read_dict[junc].keys():
      if len(junc_read_dict[junc][read_name]) == 2:
        out_dict["id"].append(read_name)
#         info = [read_name]
        r1 = junc_read_dict[junc][read_name][0]
        r2 = junc_read_dict[junc][read_name][1]
#        print("{},{},{}".format(r1.name,r1.refName, r2.refName))
        read_class = get_read_class(r1, r2)
        out_dict["class"].append(read_class)
        out_dict["junction"].append(r1.refName)
        out_dict["numN"].append(r1.numN)
        out_dict["readLen"].append(r1.readLen)
        out_dict["posA"].append(r1.offsetA)
        out_dict["posB"].append(r1.offsetB)
        out_dict["qualA"].append(r1.mapQualA)
        out_dict["qualB"].append(r1.mapQualB)
        out_dict["aScoreA"].append(r1.aScoreA)
        out_dict["aScoreB"].append(r1.aScoreB)
        out_dict["strandA"].append(r1.flagA)
        out_dict["strandB"].append(r1.flagB)
        if type(r2).__name__ == "chimReadObj":
          out_dict["fileTypeR2"].append("Chimeric")
        elif type(r2).__name__ == "readObj":
          out_dict["fileTypeR2"].append("Aligned")
        if type(r1).__name__ == "chimReadObj":
          out_dict["fileTypeR1"].append("Chimeric")
        elif type(r1).__name__ == "readObj":
          out_dict["fileTypeR1"].append("Aligned")

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
        out_dict["numNR2"].append(r2.numN)
        out_dict["readLenR2"].append(r2.readLen)
        out_dict["junctionR2"].append(r2.refName)
        out_dict["posR2A"].append(r2.offsetA)
        out_dict["posR2B"].append(r2.offsetB)
        out_dict["qualR2A"].append(r2.mapQualA)
        out_dict["qualR2B"].append(r2.mapQualB)
        out_dict["aScoreR2A"].append(r2.aScoreA)
        out_dict["aScoreR2B"].append(r2.aScoreB)
        out_dict["strandR2A"].append(r2.flagA)
        out_dict["strandR2B"].append(r2.flagB)
#         info.append(r2)
#         print("info", info)
  df = pd.DataFrame.from_dict(out_dict)
  df.to_csv(out_file,sep="\t",index=False)
#         out.write("\t".join(info))
#         out.write("\n")
#       else:
#         print(junc_read_dict[junc][read_name])
#   out.close()

   
def main():
  t0 = time.time()
  parser = argparse.ArgumentParser(description="create class input file")
  parser.add_argument("-g", "--gtf_path", help="the path to the gtf file to use for annotation")
  parser.add_argument("-a", "--assembly", help="The name of the assembly to pre-load annotation (so, mm10 for the 10th mouse assembly)")
  parser.add_argument("-i", "--input_path", help="the prefix to the STAR Aligned.out.sam and Chimeric.out.sam directory")
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
  samFile2 = "{}2Chimeric.out.sam".format(args.input_path)
  samFile3 = "{}2Aligned.out.sam".format(args.input_path)
  samFile4 = "{}1Aligned.out.sam".format(args.input_path)

  read_junc_dict, junc_read_dict = STAR_parseSam(samFile1, "r1chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)

  print("parsed r1chim", time.time() - t0)

  read_junc_dict, junc_read_dict = STAR_parseSam(samFile4, "r1align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
  print("parsed r1align", time.time() - t0)


  read_junc_dict, junc_read_dict = STAR_parseSam(samFile2, "r2chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
  print("parsed r2chim", time.time() - t0)

  read_junc_dict, junc_read_dict = STAR_parseSam(samFile3, "r2align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
  print("parsed all", time.time() - t0)
#  write_class_file(junc_read_dict,"/scratch/PI/horence/JuliaO/single_cell/scripts/output/create_class_input/{}.tsv".format(fastq_id))
  write_class_file(junc_read_dict,"{}class_input.tsv".format(args.input_path))


#time.time() - t0

main()
