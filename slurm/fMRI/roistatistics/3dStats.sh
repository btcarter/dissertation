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
PARTICIPANTS=${PROJECT}/dissertation/participants.tsv


#### Find stats for masks
R_MASK=${PROJECT}/masks/ns_reading #mask created from NS map
OM_MASK=${PROJECT}/masks/ns_om

for MASK in ${R_MASK} ${OM_MASK}; do

  # get stats from the block contrast
  RES_DIR=${PROJECT}/dissertation/roiStats/${MASK}  #directory with group results

  if [ ! -d ${RES_DIR} ]
    then mkdir -p ${RES_DIR}
  fi

  OUT=${RES_DIR}/block.txt   #statistics data

  if [ ! -f ${OUT} ]
    then touch ${OUT}
  fi

  #path and prefix for participant's template aligned deconvolution file with subbrick
  # blocked contrast
  DECON=block/block_deconv_blur5_ANTS_resampled+tlrc[1]

  for i in $(cat ${PARTICIPANTS}); do
    stat="3dROIstats -minmax -sigma -1DRformat -mask ${MASK}_mask+tlrc ${SUBJ_DIR}/${i}/${DECON}"
    ${stat} >> ${OUT}
  done

  # get stats from the predictability contrasts
  # ortho
  OUT=${RES_DIR}/ortho.txt   #statistics data

  if [ ! -f ${OUT} ]
    then touch ${OUT}
  fi

  DECON=predictability/predictability_deconv_blur5_ANTS_resampled+tlrc[5]

  for i in $(cat ${PARTICIPANTS}); do
    stat="3dROIstats -minmax -sigma -1DRformat -mask ${MASK}_mask+tlrc ${SUBJ_DIR}/${i}/${DECON}"
    ${stat} >> ${OUT}
  done

  # lsa
  OUT=${RES_DIR}/lsa.txt   #statistics data

  if [ ! -f ${OUT} ]
    then touch ${OUT}
  fi

  DECON=predictability/predictability_deconv_blur5_ANTS_resampled+tlrc[3]

  for i in $(cat ${PARTICIPANTS}); do
    stat="3dROIstats -minmax -sigma -1DRformat -mask ${MASK}_mask+tlrc ${SUBJ_DIR}/${i}/${DECON}"
    ${stat} >> ${OUT}
  done

  # pos
  OUT=${RES_DIR}/pos.txt   #statistics data

  if [ ! -f ${OUT} ]
    then touch ${OUT}
  fi

  DECON=predictability/predictability_deconv_blur5_ANTS_resampled+tlrc[1]

  for i in $(cat ${PARTICIPANTS}); do
    stat="3dROIstats -minmax -sigma -1DRformat -mask ${MASK}_mask+tlrc ${SUBJ_DIR}/${i}/${DECON}"
    ${stat} >> ${OUT}
  done

done
# Do stats for OM mask
