#!/bin/bash

#######################################
#PREPROCESSING BATCH SUBMISSION SCRIPT#
#######################################

#Written by Ben Carter 03/27/2017

#############
#ENVIRONMENT#
#############

HOME_DIR=/fslhome/ben88/compute/NihReadingStudy
SCRIPT_DIR=~/analyses/dissertation/fMRI/gort_predictability

##########
#COMMANDS#
##########

#Create logfiles directory
var=`date +"%Y%m%d-%H%M%S"`
mkdir -p ~/logfiles/$var

#Submit the job script
sbatch \
    -o ~/logfiles/${var}/output_group_predWhole.txt \
    -e ~/logfiles/${var}/error_group_predWhole.txt \
    ${SCRIPT_DIR}/3dttest_predMaskWhole_job.sh \
    sleep 1

sbatch \
    -o ~/logfiles/${var}/output_group_predRead.txt \
    -e ~/logfiles/${var}/error_group_predRead.txt \
    ${SCRIPT_DIR}/3dttest_predMaskRead_job.sh \
    sleep 1

sbatch \
    -o ~/logfiles/${var}/output_group_predOM.txt \
    -e ~/logfiles/${var}/error_group_predOM.txt \
    ${SCRIPT_DIR}/3dttest_predMaskOM_job.sh \
    sleep 1

sbatch \
    -o ~/logfiles/${var}/output_group_predSTRI.txt \
    -e ~/logfiles/${var}/error_group_predSTRI.txt \
    ${SCRIPT_DIR}/3dttest_predMaskSTRI_job.sh \
    sleep 1
