import pandas as pd
import pickle

def main():
  exon_bounds = pickle.load(open("/scratch/PI/horence/JuliaO/single_cell/STAR_wrapper/annotators/hg38_exon_bounds.pkl","rb"))
  splices = pickle.load(open(,"rb"))

main()
