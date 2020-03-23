#!/bin/bash
#############################
# File Name : install_py_R_depends.sbatch
#
# Purpose : [???]
#
# Creation Date : 23-03-2020
#
# Last Modified : Mon 23 Mar 2020 11:16:30 AM PDT
#
# Created By : Rob Bierman
#
##############################

#########################################################
#                                                       #
#      Parameters that should be set every time         #
#                                                       #
#########################################################
#Single commented out SBATCH are active, more than that is inactive
#SBATCH -p horence                          # which node to run on
#SBATCH --time=8:00:00                     # how much time to run
#SBATCH --mem=5000                         # how much mem in MBs
#SBATCH --job-name=install_deps


#########################################################
#                                                       #
#               More optional parameters                #
#                                                       #
#########################################################
##SBATCH --output=slurm.out                 # slurm.out file
##SBATCH --error=slurm.err                  # slurm.err file
##SBATCH --mail-type=END,FAIL               # notifications for job done & fail
##SBATCH --mail-user=rbierman@stanford.edu  # email to send it to
##SBATCH --dependency=afterany:???      # wait to submit until this job num finishes
##SBATCH --array=1-35                       # to submit an array of jobs
#echo $SLURM_ARRAY_TASK_ID                  # this variable takes on the int of the current array


#Specify to use the sherlock installed R
ml R/3.6.1
echo `which Rscript`

#Install the R libraries (takes a long time)
Rscript r_requirements.R


#Specify to use the sherlock installed python
ml python/3.6.1

echo `which pip3`

pip3 install --user -r py_requirements.txt



