#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 08/25/2020

#############
#ENVIRONMENT#
#############

HOME_DIR=/fslhome/ben88/compute_dir/NihReadingStudy/
SCRIPT_DIR=~/analyses/dissertation/fMRI/predictability

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
sbatch \
    -o ~/logfiles/${var}/output.txt \
    -e ~/logfiles/${var}/error.txt \
    ${SCRIPT_DIR}/3dLmer.sh
    sleep 1
