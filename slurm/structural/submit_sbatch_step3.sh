#!/bin/bash

# Written by Ben Carter, 2019-04-11.

#####################
# --- VARIABLES --- #
#####################

STUDY=~/compute/NihReadingStudy					    # location of study directory
TEMPLATE_DIR=${STUDY}/template 							# destination for template output
SCRIPT_DIR=~/analyses/dissertation/structural			# location of scripts that might be referenced; assumed to be separate from the data directory.
LIST=${STUDY}/dissertation/participants.tsv 					# list of participant IDs
LOG=~/logfiles											# where to put documentation about errors and outputs
TIME=`date '+%Y_%m_%d-%H_%M_%S'`						# time stamp for e's and o's

# check for participant list
if [ ! -f ${LIST} ]; then
	echo ${LIST} does not exist, check your variable LIST
	exit 1
fi

# check for logfiles destination
OUT=${LOG}/TEMPLATE_STEP3_${TIME}
if [ ! -d ${OUT} ]; then
	mkdir -p ${OUT}
fi

# submit the job script once
sbatch \
-o ${OUT}/output_step3.txt \
-e ${OUT}/error_step3.txt \
${SCRIPT_DIR}/sbatch_step3.sh

sleep 1
