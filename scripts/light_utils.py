from collections import defaultdict
import math
import numpy as np
import os
import pandas as pd
import pickle
import pysam
import re

import sys
#sys.path.insert(1, '/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/scripts/')
import annotator

def get_loc_flag(row):
  if "|fus" in row["refName_ABR1"]:
    return 1
  if "|sc" in row["refName_ABR1"]:
    return 0
  r_strand = row["read_strandR1A"]
  if math.isnan(row["juncPosR2A"]):
    return 0
  if "|lin" in row["refName_ABR1"]:
    if r_strand == "+":
      if row["juncPosR2A"] > row["juncPosR1A"]:
        return 1
      else:
        return 0
    if r_strand == "-":
#       print(row["juncPosR2A"],row["juncPosR1A"])
      if (row["juncPosR2A"]) < row["juncPosR1A"]:
        return 1
      else:
        return 0
  if "|rev" in row["refName_ABR1"]:
    if (row["juncPosR1A"] <= row["juncPosR2A"] <= row["juncPosR1B"]) or (row["juncPosR1B"] <= row["juncPosR2A"] <= row["juncPosR1A"]):
      return 1
    else:
      return 0
  return "error"

def parse_cigar(cigar):
  matches = re.findall(r'(\d+)([A-Z]{1})', cigar)
  val = 0
  for m in matches:
    if m[1] == "M":
      val += int(m[0])
    elif m[1] == "N":
      val += int(m[0])
    elif m[1] == "D":
      val += int(m[0])
  return val

def read_strand(flag, fill_char = np.nan):
  if flag == fill_char:
    return flag
  sign_dict = {"0" : "+", "1" : "-"}
  return sign_dict['{0:012b}'.format(flag)[7]]

def chim_refName(flags, cigars, offsets, rnames, ann):
    sign_dict = {"0" : "+", "1" : "-"}
    signs = []
    for i in range(len(flags)):
        f = flags[i]
        signs.append(sign_dict['{0:012b}'.format(f)[7]])


    # determined by comparing Chimeric.out.junction and Chimeric.out.sam
    if signs[0] == "+":
      cig_val = parse_cigar(cigars[0])
      posFirst = int(offsets[0]) + cig_val - 1
    elif signs[0] == "-":
      posFirst = int(offsets[0])
    else:
      print("flags", flags)

    if signs[1] == "+":
      posSecond = int(offsets[1])
    elif signs[1] == "-":
      cig_val = parse_cigar(cigars[1])
      posSecond = int(offsets[1]) + cig_val - 1



    gene1, strand1 =  ann.get_name_given_locus(rnames[0], posFirst)
    gene2, strand2 =  ann.get_name_given_locus(rnames[1], posSecond)

    if rnames[0] != rnames[1]:
        juncType = "fus"
    elif signs[0] != signs[1]:
      juncType = "sc"
    elif (signs[0] == "+" and posFirst > posSecond) or (signs[0] == "-" and posFirst < posSecond):
        juncType = "rev"
    elif (signs[0] == "+" and posFirst < posSecond) or (signs[0] == "-" and posFirst > posSecond):
         juncType = "lin"
    else:
        juncType = "err"
#    return "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[0], "", posFirst, signs[0], rnames[1], "", posSecond, signs[1], juncType)
    unchanged = "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[0], gene1, posFirst, strand1, rnames[1], gene2, posSecond, strand2, juncType)

    return unchanged, rnames[0], gene1, int(posFirst), rnames[1], gene2, int(posSecond)
#     if juncType == "sc":
#       if posFirst < posSecond:
#         return unchanged, "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[0], gene1, posFirst, strand1, rnames[1], gene2, posSecond, strand2, juncType)
#       else:
#         return unchanged, "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[1], gene2, posSecond, strand2, rnames[0], gene1, posFirst, strand1, juncType)
#     if signs[0] == "+":
#       return unchanged, "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[0], gene1, posFirst, strand1, rnames[1], gene2, posSecond, strand2, juncType)
#     # reverse names if on minus strand
#     elif signs[0] == "-":
#       return unchanged, "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[1], gene2, posSecond, strand2, rnames[0], gene1, posFirst, strand1, juncType)

def readObj_refname(flag, cigar, seqname, position, ann, fill_char):
  flag_dict = {0 : "+", 256 : "+", 16 : "-", 272 : "-"}
  read_strand = flag_dict[flag]
  if "N" not in cigar:
#    gene, strand = get_name_strand(seqname, int(position), ann) #ann.get_name_given_locus(seqname, int(position))
    gene, strand = ann.get_name_given_locus(seqname, int(position))
    return "{}:{}:{}".format(seqname,gene,strand), seqname,gene, position, fill_char, fill_char, fill_char

  matches = re.findall(r'(\d+)([A-Z]{1})', cigar)

  # find the largest N (the one to split on)
  max_N_ind = None
  max_N_val = 0
  for i in range(len(matches)):
      m = matches[i]
      if m[1] == "N":
          if int(m[0]) > max_N_val:
              max_N_ind = i
              max_N_val = int(m[0])

  # get the first base of the junction
  offset1 = position
  for i in range(max_N_ind):
      m = matches[i]
      if m[1] in ["M","N","D"]:
          offset1 += int(m[0])

  # get the second base of the junction
  offset2 = offset1 + max_N_val
  for i in range(max_N_ind + 1, len(matches) + 1):
      m = matches[i]
      if m[1] == "M":
          break

      elif m[1] in ["N","D"]:
          offset2 += int(m[0])
  offset1 -= 1
  gene1, strand1 = ann.get_name_given_locus(seqname, offset1)
  gene2, strand2 = ann.get_name_given_locus(seqname, offset2)

  read_class = "lin"

  return "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(seqname, gene1, int(offset1), strand1,seqname, gene2, int(offset2), strand2, read_class), seqname, gene1, offset1, seqname, gene2, offset2
#   if read_strand == "+":
#     return "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(seqname, gene1, offset1, strand1,seqname, gene2, offset2, strand2, read_class), "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(seqname, gene1, offset1, strand1,seqname, gene2, offset2, strand2, read_class)
#   else:
#     return  "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(seqname, gene1, offset1, strand1,seqname, gene2, offset2, strand2, read_class), "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(seqname, gene2, offset2, strand2,seqname, gene1, offset1, strand1, read_class)

def get_SM(cigar, fill_char = np.nan):
  if not isinstance(cigar, str):
    return fill_char, fill_char, fill_char, fill_char
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

def nmm(MD):
  return len(''.join(filter(["A","C","G","T"].__contains__, MD)))

def split_cigar_align(cigar, fill_char = np.nan):
  if "N" not in cigar:
    return cigar, fill_char
  matches = re.findall(r'(\d+)([A-Z]{1})', cigar)
  
  # find the largest N (the one to split on)
  max_N_ind = None
  max_N_val = 0
  for i in range(len(matches)):
      m = matches[i]
      if m[1] == "N":
          if int(m[0]) > max_N_val:
              max_N_ind = i
              max_N_val = int(m[0])
  cigar1 = "".join(["".join(m) for m in matches[:max_N_ind]])
  cigar2 = "".join(["".join(m) for m in matches[max_N_ind + 1:]])
  return cigar1, cigar2

def split_cigar_chim(cigar):
    matches = re.findall(r'(\d+)([A-Z]{1})', cigar)
    if (matches[0][1] == "S") and (matches[-1][1] != "S"):
      cigar1 = "".join(["".join(m) for m in matches[1:]])
    elif (matches[-1][1] == "S") and (matches[0][1] != "S"):
      cigar1 = "".join(["".join(m) for m in matches[:-1]])
    else:
      assert (matches[0][1] == "S") and (matches[-1][1] == "S")
      if int(matches[0][0]) > int(matches[-1][0]):
        cigar1 = "".join(["".join(m) for m in matches[1:]])
      else:
        cigar1 = "".join(["".join(m) for m in matches[:-1]])
    return cigar1
