import pandas as pd
import pickle

def main():
  exon_bounds = pickle.load(open("/oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/annotators/hg38_exon_bounds.pkl","rb"))
  splices = pickle.load(open(,"rb"))

main()
