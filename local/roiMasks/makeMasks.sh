#!/bin/bash

# this will create masks for 3droistatistics

INPUT=~/compute/NihReadingStudy/dissertation/block/blockWhole+tlrc
Z_brick=4
T_brick=5
neighbors=1
CLUST=39
left=-3.2905
right=3.2905
PREFIX=~/compute/NihReadingStudy/masks/roistats_block_pos_mask

3dClusterize \
-nosum \
-1Dformat \
-inset ${INPUT} \
-idat ${Z_brick} \
-ithr ${T_brick} \
-NN ${neighbors} \
-clust_nvox ${CLUST} \
-1sided RIGHT_TAIL ${right} \
-pref_map ${PREFIX}
