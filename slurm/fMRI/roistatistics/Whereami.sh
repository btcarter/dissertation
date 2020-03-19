#!/bin/bash

# this will use the afni atlases to tell you where the blobs are in the brain
MASKDIR=~/compute/NihReadingStudy/masks
MASKLIST=(ns_reading_func_mask+tlrc ns_om_func_mask+tlrc)

cd $MASKDIR
for i in ${MASKLIST[@]}; do

  touch whereami_${i}.txt

  whereami -atlas CA_N27_ML -omask $i >> whereami_${i}.txt

done
