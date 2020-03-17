#!/bin/bash

# this will create masks for 3droistatistics

INPUT=~/compute/NihReadingStudy/masks/eye_movements_association-test_z_FDR_0.01.nii
Z_brick=0
T_brick=0
neighbors=1
CLUST=39
left=-0.0001
right=0.0001
PREFIX=~/compute/NihReadingStudy/masks/ns_om_mask

3dClusterize \
-nosum \
-1Dformat \
-inset ${INPUT} \
-idat ${Z_brick} \
-ithr ${T_brick} \
-NN ${neighbors} \
-clust_nvox ${CLUST} \
-bisided ${left} ${right} \
-pref_map ${PREFIX}


INPUT=~/compute/NihReadingStudy/masks/reading_association-test_z_FDR_0.01.nii
Z_brick=0
T_brick=0
neighbors=1
CLUST=39
left=-0.0001
right=0.0001
PREFIX=~/compute/NihReadingStudy/masks/ns_reading_mask

3dClusterize \
-nosum \
-1Dformat \
-inset ${INPUT} \
-idat ${Z_brick} \
-ithr ${T_brick} \
-NN ${neighbors} \
-clust_nvox ${CLUST} \
-bisided ${left} ${right} \
-pref_map ${PREFIX}
