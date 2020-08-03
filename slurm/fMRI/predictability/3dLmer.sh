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
# this script is going to attempt a linear mixed effects model on various predictabilities to examine group differences.


###############
#ENVIRONMENTAL#
###############
AFNI_BIN=/fslhome/ben88/abin

###########
#VARIABLES#
###########
PREFIX=massiveLMER
HOME_DIR=/fslhome/ben88/compute_dir/NihReadingStudy
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

module load r

3dLMEr \
	-prefix ${PREFIX} \
	-jobs ${JOBS} \
	-mask ${MASK} \
	-model 'group+(1|Subj)' \
	-gltCode dyslexia 'group : 1*dyslexia' \
	-gltCode control 'group : 1*control' \
	-gltCode control-dyslexia 'group : 1*control -1*dyslexia' \
	-dataTable \
	Subj  group InputFile \
Luke_Nih_C001	control	${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C002	dyslexia	${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C003	control	${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C004	control	${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C005	control	${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C006	control	${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C007	control	${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C008	control	${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C009	control	${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C010	control	${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C011	control	${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C012	control	${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C013	control	${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C014	control	${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C015	control	${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C016	control	${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C017	control	${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C018	control	${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C019	control	${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C020	control	${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C021	control	${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C022	control	${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_C023	control	${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D001	dyslexia	${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D002	dyslexia	${FUNC_DIR}/Luke_Nih_D002/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D003	dyslexia	${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D004	dyslexia	${FUNC_DIR}/Luke_Nih_D004/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D005	dyslexia	${FUNC_DIR}/Luke_Nih_D005/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D006	dyslexia	${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D007	dyslexia	${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D008	dyslexia	${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D009	dyslexia	${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D010	dyslexia	${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D011	dyslexia	${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D012	dyslexia	${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D013	dyslexia	${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D014	dyslexia	${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D015	dyslexia	${FUNC_DIR}/Luke_Nih_D015/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D016	dyslexia	${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D017	dyslexia	${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D018	dyslexia	${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D019	dyslexia	${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D020	dyslexia	${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D021	dyslexia	${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D022	dyslexia	${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D023	dyslexia	${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D024	dyslexia	${FUNC_DIR}/Luke_Nih_D024/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D025	dyslexia	${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D026	dyslexia	${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D027	dyslexia	${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D028	dyslexia	${FUNC_DIR}/Luke_Nih_D028/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
Luke_Nih_D029	dyslexia	${FUNC_DIR}/Luke_Nih_D029/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'
