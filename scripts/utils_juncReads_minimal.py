# main data structures for tracking junctions and aligned reads and their associated properties

import re
from collections import namedtuple
from collections import deque
from numpy import mean
import sys
sys.path.insert(0, '/scratch/PI/horence/JuliaO/single_cell/scripts/')
import annotator

POS_MATCH_FLAG = 0  # value used in sam file to indicate alignment to forward strand
REV_MATCH_FLAG = 16  # value used in sam file to indicate alignment to reverse strand
## locations of information in the junction id when it is split using id_patt regex
G_CHR = 1
G_GENE1 = 2
G_POS1 = 3
G_GENE2 = 4
G_POS2 = 5
G_JUNC_TYPE = 6
G_JUNC_STRAND = 7
BUFFER = 15  # allow wiggle room to minimize anomalies / decoys due to sequencing errors or adaptor sequence alignment
UNALIGNED_BUFFER = 50  # allow extra wiggle room for unaligned because the headers contain bins, not exact alignment positions
JUNC_MIDPOINT = 150  # we take 150bp from each exon to create a junction sequence
MIN_MAPQUAL = 0 # minimum mapping quality to consider a read as providing any info  

# junction ids look like chr10|TTC40:134751179|MYC1:134722640|reg|-
# where we are interested in chr10, TTC40, 134751179, MYC1, 134722640, reg, and -
id_patt = re.compile("(.+?)\|(.+?):(.+?)\|(.+?):(.+?)\|(.+?)\|(\-|\+)")

# MD strings look like 0N0N0N0N0N0N35T0A0G0G0G1T1C29 or 35T0A0G0G0G1T1C29N0N0 with any number of 0N or N0 repeats
# where we are interested in the repeats 0N0N0N0N0N0N and N0N0
md_patt = re.compile("^((?:0N)*).+?((?:N0)*)$")

# Contains read and its mates that mapped to the genome or junction database.
# Can have mate mapping to both since the alignment of all mates is done to both
# indexes. Also knows whether it looks like a circle or a decoy.
class juncReadObj:
    
    def __init__(self, read):
        self.juncRead = read  # read object that aligned to junction
        self.mateGenomic = None # read object for mate that aligned to the genome
        self.mateJunction = None # read object for mate that aligned to the junction index
        self.mateRegJunction = None # read object for mate that aligned to the regular-only junction index
        self.mateDenovoJunction = None # read object for mate that aligned to the denovo junction index
        self.readType = None # will be updated to "c", "d","u", "l", a", or "i" for circular, decoy, mate-unmapped, linear, anomaly or ignore
        self.useMate = None # will be updated to self.mateGenomic, self.mateJunction, or self.mateRegJunction after we have all options
        self.readStat = None # will be updated to include statistic I want to use for evaluating this read (for example avg)
    
    def __str__(self):
        msg = "juncRead: " + str(self.juncRead)
        msg += "\nmateGenomic: " + str(self.mateGenomic)
        msg += "\nmateJunction: " + str(self.mateJunction)
        msg += "\nmateRegJunction: " + str(self.mateRegJunction)
        msg += "\nmateDenovoJunction: " + str(self.mateDenovoJunction)
        msg += "\nreadType: " + str(self.readType)
        msg += "\nuseMate: " + str(self.useMate)
        msg += "\nreadStat: " + str(self.readStat)
        return msg        
    
    # param junc: juncObj
    # param isSingleEnd: T/F since we need to know if the mate isn't there because it never existed or because it didn't align or pass quality filters
    # param isUnalignedMode: T/F since the header info is slightly different for the index built for the denovo run (only applicable to scrambled junctions for now)
    def updateInfo(self, junc, isSingleEnd, isUnalignedMode):
        # if the junction-spanning read had poor mapping quality,
        # it will end up being placed in the multi-mapped bucket
        # so no need to take a look at mates and read types
        # otherwise, pick a mate and calculate values based on mate selected
        if int(self.juncRead.mapQual) >= MIN_MAPQUAL:
            if not isSingleEnd:
                self.useMate = self.selectMate()
            self.readType = self.selectReadType(junc, isSingleEnd, isUnalignedMode)
            self.readStat = self.calcReadStat()    
    
    # set useMate
    # select the highest scoring alignment for Rd2. If multiple alignments have the same
    # score, default to genome, then regular junction, then scrambled.
    # only consider mates with good mapping quality, since poor quality reads most likely came from another location
    def selectMate(self):
        possibleMates = []
        
        
        if self.mateGenomic and int(self.mateGenomic.mapQual) >= MIN_MAPQUAL:
            possibleMates.append(self.mateGenomic)
        
        if self.mateRegJunction and int(self.mateRegJunction.mapQual) >= MIN_MAPQUAL:
            possibleMates.append(self.mateRegJunction)
        
        if self.mateJunction and int(self.mateJunction.mapQual) >= MIN_MAPQUAL:
            possibleMates.append(self.mateJunction)
        
        if self.mateDenovoJunction and int(self.mateDenovoJunction.mapQual) >= MIN_MAPQUAL:
            possibleMates.append(self.mateDenovoJunction)
        
        # mate did not align anywhere with a good mapping quality
        if len(possibleMates) == 0:
            return None
        
        # only consider those mates with the maximum alignment score
        maxAS = max(int(x.aScore) for x in possibleMates)
        possibleMates = [x for x in possibleMates if int(x.aScore) == maxAS]
        
        # if we only have one left with the max alignment score, that's the one we want
        if len(possibleMates) == 1:
            return possibleMates[0]

        # otherwise go through the priority ranking
        if self.mateGenomic in possibleMates:
            return self.mateGenomic
        
        if self.mateRegJunction in possibleMates:
            return self.mateRegJunction
        
        if self.mateJunction in possibleMates:
            return self.mateJunction
        
        if self.mateDenovoJunction in possibleMates:
            return self.mateDenovoJunction
    
    def calcReadStat(self):
        if self.juncRead:
            # if we have a mate we are using, take the avg of the 2 reads
            if self.useMate:
                return mean([int(self.juncRead.aScore), int(self.useMate.aScore)])
            # otherwise just use my score
            else:
                return float(self.juncRead.aScore)
        else:
            return None
        
    # have to handle reg junctions separately since they could have a rev mate
    # that makes them circular evidence, or they need to be assigned to linear or anomaly buckets
    # param junc: juncObj
    def selectReadType(self, junc, isSingleEnd, isUnalignedMode):
        
        # if mate mapped to neither junctions nor genome, it is unmapped
        if not isSingleEnd and not self.useMate:
            return None
        
        # for single end, we can only determine read type based on alignment to reg or scrambled junction
        if isSingleEnd:
            if junc.juncType == "reg":
                useType = "l"
            else:
                useType = "c"
        else:        
            if junc.juncType == "reg":
                useType = self.selectRegReadType(junc)
            else:
                useType = self.selectScrambledReadType(junc, isUnalignedMode)
        
        return useType        
        
    # this junction Rd1 is either dup or rev        
    def selectScrambledReadType(self, junc, isUnalignedMode):
        
        myCoord = int(junc.minPos) - JUNC_MIDPOINT + int(self.juncRead.offset)
        myEnd = myCoord + int(self.juncRead.readLen)

        # get info for mate 
        isGenomicMate = self.useMate == self.mateGenomic
        
        if isGenomicMate:
            mateChr = self.useMate.refName
            mateCoord = int(self.useMate.offset)
        else:
            match2 = id_patt.search(self.useMate.refName)  # rd2 junction id
            mateChr = match2.group(G_CHR)
            minMateJunctionPos = min(int(match2.group(G_POS1)), int(match2.group(G_POS2)))
            maxMateJunctionPos = max(int(match2.group(G_POS1)), int(match2.group(G_POS2)))
            mateCoord = minMateJunctionPos - JUNC_MIDPOINT + int(self.useMate.offset)
        
        mateEnd = mateCoord + int(self.useMate.readLen)
        
        if isUnalignedMode:
            USE_BUFFER = UNALIGNED_BUFFER
        else:
            USE_BUFFER = BUFFER
            
        # all info gathered, now see if it is consistent with circle or not
        # reads need to map in opposite orientation (have opposite flags) 
        if junc.chromosome == mateChr and int(self.juncRead.flag) != int(self.useMate.flag):
            # read2 mapping to same scrambled junction as read1 is always evidence of circle
            if self.useMate.refName == self.juncRead.refName: 
                return "c"
            # read2 mapping between read1 scrambled junction supports circle
            elif (mateCoord >= (int(junc.minPos) - USE_BUFFER) and mateCoord <= (int(junc.maxPos) + USE_BUFFER)
                  and mateEnd >= (int(junc.minPos) - USE_BUFFER) and mateEnd <= (int(junc.maxPos) + USE_BUFFER)):
                    return "c"
            # or Rd1 could map between bounds of a circle defined by scrambled junction-aligned Rd2
            # but we want to ignore these for now because they will be identified in a swapped run  
            elif (not isGenomicMate and match2.group(G_JUNC_TYPE) != "reg"
                  and myCoord >= (minMateJunctionPos - USE_BUFFER) and myCoord <= (maxMateJunctionPos + USE_BUFFER)
                  and myEnd >= (minMateJunctionPos - USE_BUFFER) and myEnd <= (maxMateJunctionPos + USE_BUFFER)):
                return "i"
            else:
                # out of bounds 
                return "d"
                    
        else:
            # the mate was on a different chromosome or alignment flags didn't agree with PE read
            return "d"
    
    # this is a reg junction. If mate maps to scrambled junction we ignore it for now,
    # since it will be picked up and considered in a swapped run (where we treat read 2 as read 1).
    def selectRegReadType(self, junc):
        
        match1 = id_patt.search(self.juncRead.refName)  # reg junction rd1 id
        myCoord = int(junc.minPos) - JUNC_MIDPOINT + int(self.juncRead.offset)
        myEnd = myCoord + int(self.juncRead.readLen)
            
        # get info for mate 
        isGenomicMate = self.useMate == self.mateGenomic
        
        if isGenomicMate:
            mateChr = self.useMate.refName
            mateCoord = int(self.useMate.offset)
        else:
            match2 = id_patt.search(self.useMate.refName)  # rd2 junction id
            mateChr = match2.group(G_CHR)
            minMateJunctionPos = min(int(match2.group(G_POS1)), int(match2.group(G_POS2)))
            maxMateJunctionPos = max(int(match2.group(G_POS1)), int(match2.group(G_POS2)))
            mateCoord = minMateJunctionPos - JUNC_MIDPOINT + int(self.useMate.offset)
                
        mateEnd = mateCoord + int(self.useMate.readLen)
        
        ###### all info gathered, now see if it is consistent with circle or not
        
        # has to be on same chromosome and mates must be aligned in opposite orientation 
        if junc.chromosome == mateChr and int(self.juncRead.flag) != int(self.useMate.flag):
            # check for evidence of linear 
            if isGenomicMate or match2.group(G_JUNC_TYPE) == "reg":
                # figure out genomic coordinate for plus and minus read
                if int(self.juncRead.flag) == POS_MATCH_FLAG:
                    plusMateCoord = myCoord 
                    minusMateCoord = mateCoord
                else:
                    plusMateCoord = mateCoord
                    minusMateCoord = myCoord
                    
                # rev read needs to map downstream, or only slightly upstream to account for errors
                if minusMateCoord >= plusMateCoord - BUFFER:
                    return "l"
                else:
                    return "a"
            else:
                # read 2 was to a scrambled junction, need to ignore for now
                return "i"
        else:
            # the mate was on a different chromosome or alignment directions do not support PE read
            return "a"

class juncObj:
    
    def __init__(self, id):
        self.id = id # junction id
        self.chromosome, self.direction, self.juncType, self.numGenes, self.minPos, self.maxPos = self.setInfo()
        self.circularReads = deque([]) # will hold list of all reads spanning this junction that support circle
        self.decoyReads = deque([]) # will hold list of all reads spanning this junction that do not support circle
        self.unmappedReads = deque([]) # will hold list of all reads spanning this junction where mate is not mapped
        self.multimappedReads = deque([]) # will hold list of all reads spanning this junction where mate has poor mapping quality
        self.linearReads = deque([]) # all that look like true linear reads
        self.anomalyReads = deque([]) # all that don't look like circular or linear
        self.unknownReads = deque([]) # will hold list of all reads initially
        self.fdr=None # will hold FDR or p-value printed in the per-junction report file  
        
    def __str__(self):
        msg = "\nid: " + str(self.id)
        msg += "\nchromosome: " + str(self.chromosome)
        msg += " direction: " + str(self.direction)
        msg += " juncType: " + str(self.juncType)
        msg += " minPos: " + str(self.minPos)
        msg += " maxPos: " + str(self.maxPos)
        msg += "\ncircularReads: " + str(len(self.circularReads))
        msg += " decoyReads: " + str(len(self.decoyReads))
        msg += " unmappedReads: " + str(len(self.unmappedReads))
        msg += " multimappedReads: " + str(len(self.multimappedReads))
        msg += " linearReads: " + str(len(self.linearReads))
        msg += " anolmalyReads: " + str(len(self.anomalyReads))
        msg += " unknownReads: " + str(len(self.unknownReads))
        msg += " fdr: " + str(self.fdr)
        
        return msg
    
    def setInfo(self):
        match = id_patt.search(self.id)
        if match:
            # if the 2 genes are the same, the junction involves only 1 gene
            if match.group(G_GENE1) == match.group(G_GENE2):
                numGenes = 1
            else:
                numGenes = 2
            
            # chr, direction, junctionType, numGenes, minPos, maxPos
            return match.group(G_CHR), match.group(G_JUNC_STRAND), match.group(G_JUNC_TYPE), numGenes, min(int(match.group(G_POS1)), int(match.group(G_POS2))), max(int(match.group(G_POS1)), int(match.group(G_POS2))) 
        else:
            return None,None,None,None,0,0
            



#readObj = namedtuple('readObj', ['name', 'flag', 'refName', 'offset', 'aScore', 'nextBest', 'mapQual', 'baseName', 'readLen', 'numN', 'cigar'])
readObj = namedtuple('readObj', ['name', 'flagA', 'flagB', 'refName', 'offsetA', 'offsetB', 'aScoreA', 'aScoreB', 'nextBestA', 'nextBestB', 'mapQualA', 'mapQualB', 'baseName', 'readLen', 'numN', 'cigarA', 'cigarB', 'MDA', 'MDB', 'nmmA', 'nmmB'])

chimReadObj = namedtuple('chimReadObj', ['name', 'flagA', 'flagB', 'refName', 'offsetA', 'offsetB', 'aScoreA', 'aScoreB', 'nextBestA', 'nextBestB', 'mapQualA', 'mapQualB', 'baseName', 'readLen', 'numN', 'cigarA', 'cigarB', 'MDA', 'MDB', 'nmmA', 'nmmB'])

def readObj_refname(cigar, seqname, position, ann):
  if "N" not in cigar:
    gene, strand = ann.get_name_given_locus(seqname, int(position))
    return "{}:{}:{}".format(seqname,gene,strand)

 # print("cigar",cigar)

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
  gene1, strand1 =  ann.get_name_given_locus(seqname, offset1)
  gene2, strand2 = ann.get_name_given_locus(seqname, offset2)
#  if (strand1 == "+") and (offset1 > offset2):
#    read_class = "rev"
#  elif (strand1 == "-") and (offset2 > offset1):
#    read_class = "rev"
#  else:
  read_class = "lin"

  return "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(seqname, gene1, offset1, strand1,seqname, gene2, offset2, strand2, read_class)
  
  



# param vals: result of calling line.strip().split() on a non-header line from sam file.
# param readIdStyle: for now, options are just "appended" or "complete".
#                    "appended" means /1 or /2 added to read 1 or read 2 respectively
#                    "complete" means same id used in read1 and read2 files 
# Need to store read length because trimming could result in different lengths of reads within a single dataset
def newReadObj(vals, readIdStyle, ann, fill_char = "NA"):
    flag_dict = {0 : "+", 256 : "+", 16 : "-", 272 : "-"}

    numN = 0
    mmStr = ""
    myScore = None
    myNextBest = None
    optFields = vals[11:]  
    
    for x in optFields:
        curOpt = x.split(":")
        if curOpt[0] == "AS":
            myScore = curOpt[2]
        elif curOpt[0] == "XS":  # next best score
            myNextBest = curOpt[2]
        elif curOpt[0] == "XN":  # num N in reference
            numN = int(curOpt[2]) 
        elif curOpt[0] == "MD":  # string representing mismatch locations
            mmStr = curOpt[2]
            
    # correct for N-penalty in junction alignments and update alignment score as needed
    if numN > 0:
        match = id_patt.search(vals[2])  # if this is a junction alignment, refName will fit this pattern
        if match:  # only want to adjust junction alignments 
            # get MD string, string representation of where the mismatches or Ns occurred
            # if Ns are on left the pattern is 0N, if on right of match the pattern is N0
            match_md = md_patt.search(mmStr)
            numOinStr = match_md.group(1).count("0N")
            numNinStr = match_md.group(2).count("N0")
            # confirm agreement between XN and MD string
            if numNinStr == numN or numOinStr == numN or numNinStr + numOinStr == numN: 
                myOrigScore = myScore
                myScore = str(int(myScore) + numN) # 1 was deducted from score for each N matched in reference so add back, keep as string for consistency
            else:
                print("could not update AS for", vals[0], "MD and XN do not agree", mmStr, str(numN))
                    
    if readIdStyle == "appended":        
        myBaseName = vals[0][:-1]  # name without trailing 1 or 2 so we can quickly match up paired reads
    else:
        myBaseName = vals[0]  # or sometimes the read ids are already the same in the 2 separate files  
#    print("refName","{}:{}:{}".format(vals[2],",".join(gtf_data.gene_names_at_locus(contig=vals[2][3:], position=int(vals[3]))),flag_dict[int(vals[1])]) )
#    return readObj(name=vals[0], flag=int(vals[1]), refName="{}:{}:{}".format(vals[2],"", flag_dict[int(vals[1])]), offset=vals[3], aScore=myScore, nextBest=myNextBest, mapQual=vals[4], baseName=myBaseName, readLen=len(vals[9]), numN=numN, cigar=vals[5])
    cigar_string = get_cigar_string(vals[5], int(vals[1]))
    return readObj(name=vals[0], flagA=int(vals[1]), flagB=fill_char, refName=readObj_refname(cigar_string, vals[2], int(vals[3]),  ann),offsetA=vals[3], offsetB=fill_char, aScoreA=myScore, aScoreB=fill_char, nextBestA=myNextBest, nextBestB=fill_char, mapQualA=vals[4], mapQualB=fill_char, baseName=myBaseName, readLen=len(vals[9]), numN=numN, cigarA=cigar_string, cigarB=fill_char, MDA=mmStr, MDB=fill_char, nmmA = nmm(mmStr), nmmB=fill_char)

def nmm(MD): 
  return len(''.join(filter(["A","C","G","T"].__contains__, MD)))

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


#    if signs[0] == "+":
#        cig_val = parse_cigar(cigars[0])
#        posFirst = int(offsets[0]) + cig_val - 1
#    else:
#        posFirst = int(offsets[0])
#    if signs[1] == "+":
#        posSecond = int(offsets[1])
#    else:
#        cig_val = parse_cigar(cigars[0])
#        posSecond = int(offsets[1]) + cig_val - 1
    gene1, strand1 = ann.get_name_given_locus(rnames[0], posFirst)
    gene2, strand2 = ann.get_name_given_locus(rnames[1], posSecond)

    if rnames[0] != rnames[1]:
        juncType = "fus"
    elif signs[0] != signs[1]:
      juncType = "sc"
    elif (strand1 == "+" and posFirst > posSecond) or (strand1 == "-" and posFirst < posSecond):
        juncType = "rev"
    elif (strand1 == "+" and posFirst < posSecond) or (strand1 == "-" and posFirst > posSecond):
        juncType = "lin"
    else:
        juncType = "err"
#    return "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[0], "", posFirst, signs[0], rnames[1], "", posSecond, signs[1], juncType)
    return "{}:{}:{}:{}|{}:{}:{}:{}|{}".format(rnames[0], gene1, posFirst, strand1, rnames[1], gene2, posSecond, strand2, juncType)

def reverse_cigar(old_cigar):
  matches = ["".join(x) for x in re.findall(r'(\d+)([A-Z]{1})', old_cigar)]
  matches.reverse()
  return  "".join(matches)

def get_cigar_string(old_cigar, f):

    # the cigar string is flipped if the alignment is on the reverse strand, so we correct that
#    if '{0:012b}'.format(f)[7] == 1:
#      return reverse_cigar(old_cigar)
#    else:
    return old_cigar 
   

 

# param vals: result of calling line.strip().split() on a non-header line from sam file.
# param readIdStyle: for now, options are just "appended" or "complete".
#                    "appended" means /1 or /2 added to read 1 or read 2 respectively
#                    "complete" means same id used in read1 and read2 files 
# Need to store read length because trimming could result in different lengths of reads within a single dataset
def chim_newReadObj(vals1, vals2, readIdStyle, ann):
    assert vals1[0] == vals2[0]
    numN = 0
    mmStr = ""
    myScoreA = None
    myNextBestA = None
    myScoreB = None
    myNextBestB = None

    optFields1 = vals1[11:]  
    optFields2 = vals2[11:]
    for x in optFields1:
        curOpt = x.split(":")
        if curOpt[0] == "AS":
            myScoreA = curOpt[2]
        elif curOpt[0] == "XS":  # next best score
            myNextBestA = curOpt[2]
        elif curOpt[0] == "XN":  # num N in reference
            numN = int(curOpt[2]) 
        elif curOpt[0] == "MD":  # string representing mismatch locations
            mmStr = curOpt[2]
    for x in optFields2:
        curOpt = x.split(":")
        if curOpt[0] == "AS":
            myScoreB= curOpt[2]
        elif curOpt[0] == "XS":  # next best score
            myNextBestB = curOpt[2]
        elif curOpt[0] == "MD":  # string representing mismatch locations
            mmStrB = curOpt[2]


    if readIdStyle == "appended":        
        myBaseName = vals1[0][:-1]  # name without trailing 1 or 2 so we can quickly match up paired reads
    else:
        myBaseName = vals1[0]  # or sometimes the read ids are already the same in the 2 separate files  
#    return readObj(name=vals1[0], flag=int(vals1[1]), refName=chim_refName([int(vals1[1]),int(vals2[1])], [vals1[5],vals2[5]], [vals1[3],vals2[3]], [vals1[2],vals2[2]]), offset=vals1[3], aScore=myScore, nextBest=myNextBest, mapQual=min(vals1[4],vals2[4]), baseName=myBaseName, readLen=len(vals1[9]), numN=numN, cigar=vals1[5])
    return chimReadObj(name=vals1[0], flagA=int(vals1[1]),flagB=int(vals2[1]), refName=chim_refName([int(vals1[1]),int(vals2[1])], [vals1[5],vals2[5]], [vals1[3],vals2[3]], [vals1[2],vals2[2]], ann), offsetA=vals1[3], offsetB=vals2[3], aScoreA=myScoreA, aScoreB=myScoreB, nextBestA=myNextBestA, nextBestB=myNextBestB, mapQualA=vals1[4],mapQualB=vals2[4], baseName=myBaseName, readLen=len(vals1[9]), numN=numN, cigarA=get_cigar_string(vals1[5], int(vals1[1])), cigarB=get_cigar_string(vals2[5], int(vals2[1])), MDA=mmStr, MDB=mmStrB, nmmA = nmm(mmStr), nmmB = nmm(mmStrB))
