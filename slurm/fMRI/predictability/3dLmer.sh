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

3dLMEr \
	-prefix ${PREFIX} \
	-jobs ${JOBS} \
	-mask ${MASK} \
	-model 'group+condition+(1|Subj)' \
	-gltCode lsa 'condition : 1*lsa' \
	-gltCode pos 'condition : 1*pos' \
	-gltCode ortho 'condition : 1*ortho' \
	-gltCode pictures 'condition : 1*pictures' \
	-gltCode dys 'group : 1*dys' \
	-gltCode con 'group : 1*con' \
	-gltCode con-dys 'group : 1*con -1*dys' \
	-dataTable \
	Subj  group condition InputFile \
	Luke_Nih_C001	control	lsa	${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C001	control	ortho	${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C001	control	pictures	${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C001	control	pos	${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C003	control	lsa	${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C003	control	ortho	${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C003	control	pictures	${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C003	control	pos	${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C004	control	lsa	${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C004	control	ortho	${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C004	control	pictures	${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C004	control	pos	${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C005	control	lsa	${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C005	control	ortho	${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C005	control	pictures	${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C005	control	pos	${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C006	control	lsa	${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C006	control	ortho	${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C006	control	pictures	${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C006	control	pos	${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C007	control	lsa	${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C007	control	ortho	${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C007	control	pictures	${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C007	control	pos	${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C008	control	lsa	${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C008	control	ortho	${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C008	control	pictures	${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C008	control	pos	${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C009	control	lsa	${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C009	control	ortho	${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C009	control	pictures	${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C009	control	pos	${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C010	control	lsa	${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C010	control	ortho	${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C010	control	pictures	${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C010	control	pos	${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C011	control	lsa	${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C011	control	ortho	${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C011	control	pictures	${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C011	control	pos	${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C012	control	lsa	${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C012	control	ortho	${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C012	control	pictures	${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C012	control	pos	${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C013	control	lsa	${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C013	control	ortho	${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C013	control	pictures	${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C013	control	pos	${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C014	control	lsa	${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C014	control	ortho	${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C014	control	pictures	${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C014	control	pos	${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C015	control	lsa	${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C015	control	ortho	${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C015	control	pictures	${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C015	control	pos	${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C016	control	lsa	${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C016	control	ortho	${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C016	control	pictures	${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C016	control	pos	${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C017	control	lsa	${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C017	control	ortho	${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C017	control	pictures	${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C017	control	pos	${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C018	control	lsa	${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C018	control	ortho	${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C018	control	pictures	${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C018	control	pos	${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C019	control	lsa	${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C019	control	ortho	${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C019	control	pictures	${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C019	control	pos	${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C020	control	lsa	${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C020	control	ortho	${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C020	control	pictures	${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C020	control	pos	${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C021	control	lsa	${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C021	control	ortho	${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C021	control	pictures	${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C021	control	pos	${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C022	control	lsa	${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C022	control	ortho	${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C022	control	pictures	${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C022	control	pos	${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C023	control	lsa	${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C023	control	ortho	${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C023	control	pictures	${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C023	control	pos	${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C002	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_C002	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_C002	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_C002	dyslexia	pos	${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D001	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D001	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D001	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D001	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D002	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D002/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D002	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D002/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D002	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D002/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D002	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D002/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D003	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D003	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D003	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D003	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D004	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D004/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D004	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D004/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D004	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D004/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D004	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D004/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D005	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D005/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D005	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D005/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D005	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D005/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D005	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D005/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D006	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D006	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D006	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D006	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D007	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D007	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D007	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D007	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D008	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D008	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D008	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D008	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D009	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D009	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D009	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D009	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D010	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D010	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D010	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D010	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D011	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D011	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D011	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D011	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D012	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D012	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D012	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D012	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D013	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D013	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D013	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D013	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D014	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D014	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D014	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D014	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D015	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D015/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D015	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D015/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D015	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D015/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D015	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D015/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D016	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D016	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D016	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D016	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D017	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D017	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D017	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D017	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D018	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D018	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D018	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D018	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D019	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D019	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D019	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D019	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D020	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D020	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D020	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D020	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D021	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D021	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D021	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D021	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D022	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D022	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D022	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D022	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D023	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D023	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D023	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D023	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D024	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D024/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D024	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D024/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D024	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D024/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D024	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D024/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D025	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D025	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D025	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D025	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D026	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D026	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D026	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D026	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D027	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D027	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D027	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D027	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D028	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D028/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D028	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D028/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D028	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D028/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D028	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D028/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D029	dyslexia	lsa	${FUNC_DIR}/Luke_Nih_D029/predictability/predictability_blur5_ANTS_resampled+tlrc'[5]'  \
	Luke_Nih_D029	dyslexia	ortho	${FUNC_DIR}/Luke_Nih_D029/predictability/predictability_blur5_ANTS_resampled+tlrc'[7]'  \
	Luke_Nih_D029	dyslexia	pictures	${FUNC_DIR}/Luke_Nih_D029/predictability/predictability_blur5_ANTS_resampled+tlrc'[1]'  \
	Luke_Nih_D029	dyslexia	pos	${FUNC_DIR}/Luke_Nih_D029/predictability/predictability_blur5_ANTS_resampled+tlrc'[3]'
