#!/bin/bash

# This will convert the association maps from neurosynth into masks for
# 3droistatistics.

MASTER=~/compute/NihReadingStudy/dissertation/predictability/orthoWhole+tlrc

MASK_DIR=~/compute/NihReadingStudy/masks

3dfractionize \
-template ${MASTER} \
-input ${MASK_DIR}/reading_association-test_z_FDR_0.01.nii \
-prefix ${MASK_DIR}/reading_association

3dClusterize \
-nosum \
-1Dformat \
-inset ${MASK_DIR}/reading_association+tlrc \
-ithr 0 \
-NN 1 \
-clust_nvox 40 \
-1sided RIGHT_TAIL 0.0001 \
-pref_map ${MASK_DIR}/ns_reading_func_mask

3dfractionize \
-template ${MASTER} \
-input ${MASK_DIR}/eye_movements_association-test_z_FDR_0.01.nii \
-prefix ${MASK_DIR}/eye_movements_association

3dClusterize -nosum \
-1Dformat \
-inset ${MASK_DIR}/eye_movements_association+tlrc \
-ithr 0 \
-NN 1 \
-clust_nvox 40 \
-1sided RIGHT_TAIL 0.0001 \
-pref_map ${MASK_DIR}/ns_om_func_mask

3dfractionize \
-template ${MASTER} \
-input ${MASK_DIR}/prediction_association-test_z_FDR_0.01.nii \
-prefix ${MASK_DIR}/prediction_association

3dClusterize -nosum \
-1Dformat \
-inset ${MASK_DIR}/prediction_association+tlrc \
-ithr 0 \
-NN 1 \
-clust_nvox 40 \
-1sided RIGHT_TAIL 0.0001 \
-pref_map ${MASK_DIR}/ns_pred_func_mask
