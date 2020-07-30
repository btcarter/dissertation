#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 07/27/2020

#############
#ENVIRONMENT#
#############

HOME_DIR=/fslhome/ben88/compute_dir/NihReadingStudy
SCRIPT_DIR=~/analyses/dissertation/fMRI/predictability

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
sbatch \
    -o ~/logfiles/${var}/output_lmer.txt \
    -e ~/logfiles/${var}/error_lmer.txt \
    ${SCRIPT_DIR}/3dlmer_job.sh \
    sleep 1
