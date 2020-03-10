#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 03/27/2017

#############
#ENVIRONMENT#
#############

HOME_DIR=/fslhome/ben88/compute/NihReadingStudy
SCRIPT_DIR=~/analyses/dissertation/fMRI/block

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
sbatch \
    -o ~/logfiles/${var}/output_group_block.txt \
    -e ~/logfiles/${var}/error_group_block.txt \
    ${SCRIPT_DIR}/3dttest_block_job.sh \
    sleep 1
