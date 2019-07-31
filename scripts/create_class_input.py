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
#import pyensembl
from math import ceil
import re
import sys
import time
#sys.path.insert(0, '/scratch/PI/horence/JuliaO/KNIFE/circularRNApipeline_Cluster/analysis/')
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

def get_SM(cigar):
  matches = re.findall(r'(\d+)([A-Z]{1})', cigar)
  M = 0
  S = 0
  for m in matches:
    if m[1] == "M":
      M += int(m[0])
    elif m[1] == "S":
      S += int(m[0])
  return M, S

def write_class_file(junc_read_dict,out_file, single):
  fill_char = "NA"
  out = open(out_file,"w")
#   out.write("\t".join(["id", "class", "posA", "qualA", "aScoreA", "numN", 
#                        "posB", "qualB", "aScoreB", "readLen", "junction", "strandA", "strandB", "posR2A", 
#                        "qualR2A", "aScoreR2A", "numR2", "readLenR2", "junctionR2", "strandR2A", "posr2B", "qualR2B",
#                        "aScoreR2B", "strandR2B"]) + "\n")
#  columns = ["id", "class", "posR1A", "qualR1A", "aScoreR1A", "numNR1", 
#                       "posR1B", "qualR1B", "aScoreR1B", "readLenR1", "refNameR1", "flagR1A", "flagR1B", "strandR1A", "strandR1B", "posR2R1A", 
#                       "qualR2A", "aScoreR2A", "numNR2", "readLenR2", "refNameR2", "strandR2A", "posR2B", "qualR2B",
#                       "aScoreR2B", "strandR2B", "fileTypeR1", "fileTypeR2", "chrR1A", "chrR1B", "geneR1A", "geneR1B", "juncPosR1A", "juncPosR1B", "readClassR1", "flagR2A", "flagR2B","chrR2A", "chrR2B", "geneR2A", "geneR2B", "juncPosR2A", "juncPosR2B", "readClassR2"]
  columns = ['id', 'class', 'refNameR1', 'refNameR2', 'fileTypeR1', 'fileTypeR2', 'readClassR1', 'readClassR2','numNR1', 'numNR2', 'readLenR1', 'readLenR2', 'barcode', 'UMI']
  col_base = ['chr','gene', 'juncPos', 'gene_strand', 'aScore', 'flag', 'pos', 'qual', "MD", 'nmm', 'cigar', 'M','S',
              'NH', 'HI', 'nM', 'NM', 'jM', 'jI', 'seq']
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
  out_dict = {}
  for junc in junc_read_dict.keys():
    for read_name in junc_read_dict[junc].keys():
      if (len(junc_read_dict[junc][read_name]) == 2 and not single) or (len(junc_read_dict[junc][read_name]) == 1 and single):
        out_dict["id"] = read_name
        if single:
          read_vals = read_name.split("_")
          out_dict["barcode"] = read_vals[-2]
          out_dict["UMI"] = read_vals[-1]

        else:
          out_dict["barcode"] = fill_char
          out_dict["UMI"] = fill_char
#         info = [read_name]
        r1 = junc_read_dict[junc][read_name][0]
#        r2 = junc_read_dict[junc][read_name][1]
        split_ref = r1.refName.split("|")
#        print("{},{},{}".format(r1.name,r1.refName, r2.refName))
        out_dict["refNameR1"] = r1.refName
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
#        except Exception as e:
#          print("split_ref", split_ref)
#          print("refName", r2.refName)
#          raise e
        out_dict["gene_strandR1B"] = split_ref[1].split(":")[3]
        out_dict["chrR1A"] = split_ref[0].split(":")[0]
        out_dict["chrR1B"] = split_ref[1].split(":")[0]
        out_dict["geneR1A"] = split_ref[0].split(":")[1]
        out_dict["geneR1B"] = split_ref[1].split(":")[1]
        out_dict["juncPosR1A"] = split_ref[0].split(":")[2]
        out_dict["juncPosR1B"] = split_ref[1].split(":")[2]
        out_dict["readClassR1"] = split_ref[2]
        out_dict["MDR1A"] = r1.MDA
        out_dict["MDR1B"] = r1.MDB
        out_dict["nmmR1A"] = r1.nmmA
        out_dict["nmmR1B"] = r1.nmmB
        out_dict["cigarR1A"] = r1.cigarA
        out_dict["cigarR1B"] = r1.cigarB
        M, S = get_SM(r1.cigarA)
        out_dict["MR1A"] = M
        out_dict["SR1A"] = S
        M, S = get_SM(r1.cigarB)
        out_dict["MR1B"] = M
        out_dict["SR1B"] = S
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
        out_dict["seqR1A"] = r1.seqA
        out_dict["seqR1B"] = r1.seqB

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
          out_dict["seqR2A"] = r2.seqA
          out_dict["seqR2B"] = r2.seqB
          out_dict["numNR2"] = r2.numN
          out_dict["readLenR2"] = r2.readLen
          out_dict["refNameR2"] = r2.refName
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
          M, S = get_SM(r2.cigarA)
          out_dict["MR2A"] = M
          out_dict["SR2A"] = S
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
            M, S = get_SM(r2.cigarB)
            out_dict["MR2B"] = M
            out_dict["SR2B"] = S

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
  regimes = ["priorityAlign", "priorityChimeric"]
  for regime in regimes:
    read_junc_dict = {}
    junc_read_dict = {}
  
  #  fastq_ids = ["SRR65462{}".format(x) for x in range(73,85)]
  #  fastq_ids = ["SRR65462{}".format(x) for x in range(79,84)]
  
  #  fastq_ids = ["SRR6546284"]
  #  for fastq_id in fastq_ids:
  #  print("{}: {}".format(fastq_id, time.time() - t0))
  
    if args.single:
      samFile1 = "{}2Chimeric.out.sam".format(args.input_path)
      samFile2 = "{}2Aligned.out.sam".format(args.input_path)
    else:
      samFile1 = "{}1Chimeric.out.sam".format(args.input_path)
      samFile2 = "{}1Aligned.out.sam".format(args.input_path)
    samFile3 = "{}2Chimeric.out.sam".format(args.input_path)
    samFile4 = "{}2Aligned.out.sam".format(args.input_path)
  
  
    if regime == "priorityAlign":
      read_junc_dict, junc_read_dict = STAR_parseSam(samFile2, "r1align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
      print("parsed r1align", time.time() - t0)
      read_junc_dict, junc_read_dict = STAR_parseSam(samFile1, "r1chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
      print("parsed r1chim", time.time() - t0)
    elif regime == "priorityChimeric":
      read_junc_dict, junc_read_dict = STAR_parseSam(samFile1, "r1chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
      print("parsed r1chim", time.time() - t0)
      read_junc_dict, junc_read_dict = STAR_parseSam(samFile2, "r1align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
      print("parsed r1align", time.time() - t0)
    if not args.single:
      if regime == "priorityAlign":
        read_junc_dict, junc_read_dict = STAR_parseSam(samFile4, "r2align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
        print("parsed r2align", time.time() - t0)
        read_junc_dict, junc_read_dict = STAR_parseSam(samFile3, "r2chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
        print("parsed r2chim", time.time() - t0)
      elif regime == "priorityChimeric":  
        read_junc_dict, junc_read_dict = STAR_parseSam(samFile3, "r2chim", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
        print("parsed r2chim", time.time() - t0)
        read_junc_dict, junc_read_dict = STAR_parseSam(samFile4, "r2align", read_junc_dict, junc_read_dict, fastqIdStyle, ann)
        print("parsed r2align", time.time() - t0)
    print("len(junc_read_dict)", len(junc_read_dict))
 
    print("parsed all {}".format(regime), time.time() - t0)
  #  write_class_file(junc_read_dict,"/scratch/PI/horence/JuliaO/single_cell/scripts/output/create_class_input/{}.tsv".format(fastq_id))
    write_class_file(junc_read_dict,"{}class_input_{}.tsv".format(args.input_path, regime), args.single)


#time.time() - t0

main()
