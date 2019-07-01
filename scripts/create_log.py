# Pipeline Log
# Created by Julia Olivieri
# 8 May 2019
# Purpose: summarize job outputs into one file

import argparse
import sys

def main():
  parser = argparse.ArgumentParser(description="concatenate output and error files into one file for whole pipeline")
  parser.add_argument("-i", "--input_path", help="directory to write log")
  parser.add_argument("-j", "--job_ids", nargs="+", help="job ids to record error and output from")
  args = parser.parse_args()
#  name = sys.argv[1] 
#  jobs = sys.argv[2:]
  log = open("{}wrapper.log".format(args.input_path),"w")
  for job in args.job_ids:
    log.write("\n=====================> {} <=====================\n\n".format(job))
#    job_type = job.split("_")[0]
    with open("job_output/{}.err".format(job),"r") as err, open("job_output/{}.out".format(job),"r") as out:
      log.write(out.read())
      log.write(err.read())
#      if job_type == "cat" or job_type == "group":
#        log.write(out.read())
#      elif job_type == "whitelist":
#        log.write("\n".join(err.read().split("\n")[-7:]) + "\n")
#      elif job_type == "extract":
#        log.write("\n".join(out.read().split("\n")[-7:]) + "\n")
#      elif job_type == "map":
#        log.write(out.read())
#      elif job_type == "fc":
#        log.write("\n".join(err.read().split("\n")[-15:-9]) + "\n")
#      else:
#        log.write(out.read())
#        log.write(err.read())


  log.close()
main()
