#!/bin/bash
MASTER=~/compute/NihReadingStudy/dissertation/predictability/orthoWhole+tlrc
RADIUS=15

  # OM Mask
  TABLE=~/compute/NihReadingStudy/masks/OM

  # this will create masks for 3droistatistics
  touch ${TABLE}.1D

  INPUT=~/compute/NihReadingStudy/masks/eye_movements_association-test_z_FDR_0.01.nii
  Z_brick=0
  T_brick=0
  neighbors=1
  CLUST=39
  left=-0.0001
  right=0.0001
  PREFIX=~/compute/NihReadingStudy/masks/ns_om_mask

  3dclust \
  -1Dformat \
  -orient LPI \
  -1dindex ${Z_brick} \
  -1tindex ${T_brick} \
  -2thresh ${left} ${right} \
  -NN1 ${CLUST} \
  -dxyz=1 \
  -savemask ${PREFIX} \
  ${INPUT} >> ${TABLE}.1D

  #output coordinate data for most active voxels and center of mass
  1dcat ${TABLE}.1D'[13..15]' | awk '{ print $0, NR }' > ${TABLE}_MI.1D

  #afni makes the spherical mask
  3dUndump -prefix ${PREFIX}_sphereROI_MI -master $MASTER -orient LPI -srad $RADIUS -xyz ${TABLE}_MI.1D

  # reading mask

  TABLE=~/compute/NihReadingStudy/masks/READ

  # this will create masks for 3droistatistics
  touch ${TABLE}.1D

  INPUT=~/compute/NihReadingStudy/masks/reading_association-test_z_FDR_0.01.nii
  Z_brick=0
  T_brick=0
  neighbors=1
  CLUST=39
  left=-0.0001
  right=0.0001
  PREFIX=~/compute/NihReadingStudy/masks/ns_reading_mask

  3dclust \
  -1Dformat \
  -orient LPI \
  -1dindex ${Z_brick} \
  -1tindex ${T_brick} \
  -2thresh ${left} ${right} \
  -NN1 ${CLUST} \
  -dxyz=1 \
  -savemask ${PREFIX} \
  ${INPUT} >> ${TABLE}.1D

  #output coordinate data for most active voxels and center of mass
  1dcat ${TABLE}.1D'[13..15]' | awk '{ print $0, NR }' > ${TABLE}_MI.1D

  #afni makes the spherical mask
  3dUndump -prefix ${PREFIX}_sphereROI_MI -master ${MASTER} -orient LPI -srad ${RADIUS} -xyz ${TABLE}_MI.1D
