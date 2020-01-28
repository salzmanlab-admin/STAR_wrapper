#!/bin/bash
#
#SBATCH --job-name=class_input_test
#SBATCH --output=job_output/class_input_test.%j.out
#SBATCH --error=job_output/class_input_test.%j.err
#SBATCH --time=30:00
#SBATCH --account=horence
#SBATCH --partition=horence,owners
#SBATCH --nodes=1
#SBATCH --mem=10Gb
##SBATCH --dependency=afterok:13005642:13005643:13005644
##SBATCH --kill-on-invalid-dep=yes
date
python3 -u scripts/light_class_input.py
date
