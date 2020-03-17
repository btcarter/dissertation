#!/bin/bash

# This script will harvest relevant stats for each roi per study participant and
# put that in a table for you.
# masks were created manually via 3dClusterize, for example:
# 3dClusterize -nosum -1Dformat -inset
# /Users/ben88/Box/LukeLab/NIH Dyslexia Study/data/masks/eye movements_association-test_z_FDR_0.01.nii
# -idat 0 -ithr 0 -NN 1 -clust_nvox 40 -bisided -0.0001 0.0001 -pref_map om_mask


START=$(pwd)    #starting directory
PROJECT=/fslhome/ben88/compute/NihReadingStudy   #home directory
SUBJ_DIR=${PROJECT}/functional #directory with individual subject data
RES_DIR=${PROJECT}/dissertation/roiStats  #directory with group results
READING=${RES_DIR}/readingNetwork.txt   #statistics data
OM=${RES_DIR}/omNetwork.txt
R_MASK=${PROJECT}/masks/reading_network_mask+tlrc #mask used to create statistics
O_MASK=${PROJECT}/masks/eye_fields_mask+tlrc #mask used to create statistics
DECON=block/block_deconv_blur5_ANTS_resampled+tlrc[1]  #path and prefix for participant's template aligned deconvolution file with subbrick
PARTICIPANTS=${PROJECT}/dissertation/participants.tsv


#make results directory and stats document

if [ ! -d ${RES_DIR} ]
  then mkdir ${RES_DIR}
fi

if [ ! -f ${READING} ]
  then touch ${OUTPUT} ${OM}
fi

for i in $(cat ${PARTICIPANTS}); do
  stat="3dROIstats -minmax -sigma -1DRformat -mask ${R_MASK} ${SUBJ_DIR}/${i}/${DECON}"
  ${stat} >> ${READING}
  stat="3dROIstats -minmax -sigma -1DRformat -mask ${O_MASK} ${SUBJ_DIR}/${i}/${DECON}"
  ${stat} >> ${OM}
done
