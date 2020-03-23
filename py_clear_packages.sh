#!/bin/sh
#############################
# File Name : py_clear_packages.sh
#
# Purpose : [???]
#
# Creation Date : 23-03-2020
#
# Last Modified : Mon 23 Mar 2020 10:41:44 AM PDT
#
# Created By : Rob Bierman
#
##############################

ml python/3.6.1

pip3 freeze | xargs pip3 uninstall -y

