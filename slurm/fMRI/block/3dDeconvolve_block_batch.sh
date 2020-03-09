#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 01/10/2017

#############
#ENVIRONMENT#
#############

HOME_DIR=/fslhome/ben88/compute/NihReadingStudy/
SCRIPT_DIR=~/analyses/dissertation/fMRI/block
PART_LIST=${HOME_DIR}/dissertation/participants.tsv

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
for subj in $(cat ${PART_LIST})
    do
    sbatch \
        -o ~/logfiles/${var}/output_${subj}.txt \
        -e ~/logfiles/${var}/error_${subj}.txt \
        ${SCRIPT_DIR}/3dDeconvolve_block_job.sh \
        ${subj}
        sleep 1
done
