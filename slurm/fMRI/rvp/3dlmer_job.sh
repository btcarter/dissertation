#!/bin/bash

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "lmrvp"  # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

#############################################
# OBJECTIVE
# this script is going to attempt a linear mixed effects model on the reading v. pictures to examine group differences.


###############
#ENVIRONMENTAL#
###############
AFNI_BIN=/fslhome/ben88/abin

###########
#VARIABLES#
###########
PREFIX=rvpLMER
HOME_DIR=/fslhome/ben88/compute/NihReadingStudy
FUNC_DIR=${HOME_DIR}/functional
MASK=${HOME_DIR}/masks/nctosaMask+tlrc
RES_DIR=${HOME_DIR}/dissertation/${PREFIX}

JOBS=12


#mkdir Group_Analysis/whatever the analysis is
if [ ! -d ${RES_DIR} ]
    then
        mkdir -p ${RES_DIR}
fi

cd ${RES_DIR}

3dLMEr \
-prefix ${PREFIX} \
-jobs ${JOBS} \
-mask ${MASK} \
-model 'group+condition+(1|Subj)' \
-gltCode read 'condition : 1*read' \
-gltCode pictures 'condition : 1*pictures' \
-gltCode dys 'group : 1*dys' \
-gltCode con 'group : 1*con' \
-gltCode con-dys 'group : 1*con -1*dys' \
-dataTable \
Subj  group condition InputFile \
Luke_Nih_C001	control	pictures	${FUNC_DIR}/Luke_Nih_C001/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C001	control	reading	${FUNC_DIR}/Luke_Nih_C001/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C003	control	pictures	${FUNC_DIR}/Luke_Nih_C003/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C003	control	reading	${FUNC_DIR}/Luke_Nih_C003/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C004	control	pictures	${FUNC_DIR}/Luke_Nih_C004/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C004	control	reading	${FUNC_DIR}/Luke_Nih_C004/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C005	control	pictures	${FUNC_DIR}/Luke_Nih_C005/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C005	control	reading	${FUNC_DIR}/Luke_Nih_C005/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C006	control	pictures	${FUNC_DIR}/Luke_Nih_C006/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C006	control	reading	${FUNC_DIR}/Luke_Nih_C006/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C007	control	pictures	${FUNC_DIR}/Luke_Nih_C007/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C007	control	reading	${FUNC_DIR}/Luke_Nih_C007/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C008	control	pictures	${FUNC_DIR}/Luke_Nih_C008/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C008	control	reading	${FUNC_DIR}/Luke_Nih_C008/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C009	control	pictures	${FUNC_DIR}/Luke_Nih_C009/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C009	control	reading	${FUNC_DIR}/Luke_Nih_C009/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C010	control	pictures	${FUNC_DIR}/Luke_Nih_C010/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C010	control	reading	${FUNC_DIR}/Luke_Nih_C010/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C011	control	pictures	${FUNC_DIR}/Luke_Nih_C011/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C011	control	reading	${FUNC_DIR}/Luke_Nih_C011/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C012	control	pictures	${FUNC_DIR}/Luke_Nih_C012/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C012	control	reading	${FUNC_DIR}/Luke_Nih_C012/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C013	control	pictures	${FUNC_DIR}/Luke_Nih_C013/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C013	control	reading	${FUNC_DIR}/Luke_Nih_C013/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C014	control	pictures	${FUNC_DIR}/Luke_Nih_C014/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C014	control	reading	${FUNC_DIR}/Luke_Nih_C014/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C015	control	pictures	${FUNC_DIR}/Luke_Nih_C015/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C015	control	reading	${FUNC_DIR}/Luke_Nih_C015/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C016	control	pictures	${FUNC_DIR}/Luke_Nih_C016/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C016	control	reading	${FUNC_DIR}/Luke_Nih_C016/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C017	control	pictures	${FUNC_DIR}/Luke_Nih_C017/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C017	control	reading	${FUNC_DIR}/Luke_Nih_C017/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C018	control	pictures	${FUNC_DIR}/Luke_Nih_C018/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C018	control	reading	${FUNC_DIR}/Luke_Nih_C018/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C019	control	pictures	${FUNC_DIR}/Luke_Nih_C019/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C019	control	reading	${FUNC_DIR}/Luke_Nih_C019/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C020	control	pictures	${FUNC_DIR}/Luke_Nih_C020/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C020	control	reading	${FUNC_DIR}/Luke_Nih_C020/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C021	control	pictures	${FUNC_DIR}/Luke_Nih_C021/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C021	control	reading	${FUNC_DIR}/Luke_Nih_C021/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C022	control	pictures	${FUNC_DIR}/Luke_Nih_C022/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C022	control	reading	${FUNC_DIR}/Luke_Nih_C022/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C023	control	pictures	${FUNC_DIR}/Luke_Nih_C023/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C023	control	reading	${FUNC_DIR}/Luke_Nih_C023/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_C002	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_C002/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C002	dyslexia	reading	${FUNC_DIR}/Luke_Nih_C002/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D001	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D001/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D001	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D001/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D002	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D002/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D002	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D002/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D003	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D003/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D003	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D003/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D004	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D004/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D004	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D004/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D005	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D005/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D005	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D005/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D006	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D006/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D006	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D006/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D007	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D007/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D007	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D007/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D008	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D008/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D008	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D008/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D009	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D009/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D009	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D009/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D010	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D010/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D010	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D010/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D011	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D011/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D011	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D011/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D012	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D012/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D012	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D012/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D013	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D013/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D013	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D013/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D014	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D014/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D014	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D014/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D015	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D015/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D015	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D015/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D016	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D016/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D016	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D016/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D017	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D017/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D017	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D017/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D018	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D018/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D018	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D018/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D019	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D019/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D019	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D019/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D020	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D020/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D020	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D020/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D021	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D021/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D021	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D021/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D022	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D022/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D022	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D022/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D023	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D023/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D023	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D023/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D024	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D024/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D024	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D024/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D025	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D025/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D025	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D025/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D026	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D026/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D026	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D026/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D027	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D027/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D027	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D027/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D028	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D028/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D028	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D028/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
Luke_Nih_D029	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D029/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D029	dyslexia	reading	${FUNC_DIR}/Luke_Nih_D029/rvp/rvp_deconv_blur5_ANTS_resampled+tlrc'[1]'  \
