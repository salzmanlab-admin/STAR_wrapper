import annotator
import argparse
import pickle

def get_args():
  parser = argparse.ArgumentParser(description="create annotator for assembly")
  parser.add_argument("-g", "--gtf_path", help="the path to the gtf file to use for annotation", default=False)
  parser.add_argument("-a", "--assembly", help="The name of the assembly to pre-load annotation (so, mm10 for the 10th mouse assembly)")
  args = parser.parse_args()
  return args

def main():
  args = get_args()
  wrapper_path = "/oak/stanford/groups/horence/Roozbeh/single_cell_project/scripts/STAR_wrapper/"
  #annotator_path = "{}annotators/pyensembl_{}.pkl".format(wrapper_path, args.assembly)
  annotator_path = "{}annotators/{}.pkl".format(wrapper_path, args.assembly)
  
  
#  if os.path.exists(annotator_path):
#    ann = pickle.load(open(annotator_path, "rb"))
#  else:
  #  ann = pyensembl.Genome(reference_name = args.assembly,
  #           annotation_name = "my_genome_features",
  #           gtf_path_or_url=args.gtf_path)
  #  ann.index()
  
  ann = annotator.Annotator(args.gtf_path)
  pickle.dump(ann, open(annotator_path, "wb"))
main()
