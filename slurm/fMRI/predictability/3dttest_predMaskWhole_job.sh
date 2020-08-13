#!/bin/bash

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "content3"  # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

###############
#ENVIRONMENTAL#
###############


AFNI_BIN=/fslhome/ben88/abin


#First, use the TLRC transformation defined in struct_rotated+tlrc.HEAD to transform the
#structural BRIK dataset and the deconv1 functional dataset to TLRC space
#Now, make the group directory and cd into it
#############################################
#VARIABLES

HOME_DIR=/fslhome/ben88/compute_dir/NihReadingStudy
FUNC_DIR=${HOME_DIR}/functional
MASK=${HOME_DIR}/masks/nctosaMask+tlrc
RES_DIR=${HOME_DIR}/dissertation/predictability


#mkdir Group_Analysis/whatever the analysis is
if [ ! -d ${RES_DIR} ]
    then
        mkdir -p ${RES_DIR}
fi

cd ${RES_DIR}

#Ortho (lexical) group results
$AFNI_BIN/3dttest++ \
-prefix ortho \
-mask ${MASK} \
-Clustsim \
-AminusB \
-setA dys \
Luke_Nih_C002 ${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D001 ${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D003 ${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D006 ${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D007 ${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D008 ${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D009 ${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D010 ${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D011 ${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D012 ${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D013 ${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D014 ${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D015 ${FUNC_DIR}/Luke_Nih_D015/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D016 ${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D017 ${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D018 ${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D019 ${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D020 ${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D021 ${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D022 ${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D023 ${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D025 ${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D026 ${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_D027 ${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
-setB con \
Luke_Nih_C001 ${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C003 ${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C004 ${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C005 ${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C006 ${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C007 ${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C008 ${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C009 ${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C010 ${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C011 ${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C012 ${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C013 ${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C014 ${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C016 ${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C017 ${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C018 ${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C019 ${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C020 ${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C021 ${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C022 ${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \
Luke_Nih_C023 ${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_REML_blur5_ANTS_resampled+tlrc'[3]' \



#END
