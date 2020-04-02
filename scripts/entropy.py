import numpy as np

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
print(entropy("CAGACTCTCTCCCTATCACACACACACACACACACACACACACACACACACACACACACACCCCCATGTACTCTGCGTTGATACCACTGC"))
print(entropy("CAGACTCTCTCCCTATCACACACACACACACACACACACACACACACACACACACACACACCCCCATGTACTCTGCGTTGATACCACTGC",3))
print(entropy("GTTTTCACGTATTTGAGCCCTTTTTAATAGTTGCCTTAAATGTAAAAAAAAAAACACAAAAAAAAAAACAAACCCAAGTGGTAATCTGTC"))
print(entropy("GTTTTCACGTATTTGAGCCCTTTTTAATAGTTGCCTTAAATGTAAAAAAAAAAACACAAAAAAAAAAACAAACCCAAGTGGTAATCTGTC",3))
s1 = "GTGTGTGTAAAAAAAAAAAA"
s2 = "GTCGGCAAGCTAGACCATCG"
print(len(s1), s1, entropy(s1,5))
print(len(s2), s2, entropy(s2,5))
print(len(s2[:10]), s2[:10], entropy(s2[:10],5))
print(len(s2[10:]), s2[10:], entropy(s2[10:],5))
