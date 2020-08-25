#!/bin/sh

#SBATCH --time=02:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "lmer"  # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

###########
#VARIABLES#
###########
PREFIX=massiveLMER
HOME_DIR=~/compute_dir/NihReadingStudy
FUNC_DIR=${HOME_DIR}/functional
MASK=${HOME_DIR}/masks/nctosaMask+tlrc
RES_DIR=${HOME_DIR}/${PREFIX}
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
	-model 'group+(1|mriID)+(1|run)' \
	-gltCode dyslexia 'group : 1*dyslexia' \
	-gltCode control 'group : 1*control' \
	-gltCode control-dyslexia 'group : 1*control -1*dyslexia' \
	-dataTable \
	mriID  group  run  InputFile \
	Luke_Nih_C001  control  1  ${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C002  dyslexia  1  ${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C003  control  1  ${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C004  control  1  ${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C005  control  1  ${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C006  control  1  ${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C007  control  1  ${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C008  control  1  ${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C009  control  1  ${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C010  control  1  ${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C011  control  1  ${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C012  control  1  ${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C013  control  1  ${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C014  control  1  ${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C015  control  1  ${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C016  control  1  ${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C017  control  1  ${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C018  control  1  ${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C019  control  1  ${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C020  control  1  ${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C021  control  1  ${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C022  control  1  ${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C023  control  1  ${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D001  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D003  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D006  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D007  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D008  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D009  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D010  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D011  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D012  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D013  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D014  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D016  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D017  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D018  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D019  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D020  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D021  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D022  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D023  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D025  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D026  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D027  dyslexia  1  ${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_1_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C001  control  2  ${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C002  dyslexia  2  ${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C003  control  2  ${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C004  control  2  ${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C005  control  2  ${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C006  control  2  ${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C007  control  2  ${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C008  control  2  ${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C009  control  2  ${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C010  control  2  ${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C011  control  2  ${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C012  control  2  ${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C013  control  2  ${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C014  control  2  ${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C015  control  2  ${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C016  control  2  ${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C017  control  2  ${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C018  control  2  ${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C019  control  2  ${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C020  control  2  ${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C021  control  2  ${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C022  control  2  ${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C023  control  2  ${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D001  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D003  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D006  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D007  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D008  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D009  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D010  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D011  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D012  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D013  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D014  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D016  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D017  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D018  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D019  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D020  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D021  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D022  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D023  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D025  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D026  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D027  dyslexia  2  ${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_2_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C001  control  3  ${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C002  dyslexia  3  ${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C003  control  3  ${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C004  control  3  ${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C005  control  3  ${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C006  control  3  ${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C007  control  3  ${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C008  control  3  ${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C009  control  3  ${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C010  control  3  ${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C011  control  3  ${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C012  control  3  ${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C013  control  3  ${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C014  control  3  ${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C015  control  3  ${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C016  control  3  ${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C017  control  3  ${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C018  control  3  ${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C019  control  3  ${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C020  control  3  ${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C021  control  3  ${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C022  control  3  ${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C023  control  3  ${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D001  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D003  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D006  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D007  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D008  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D009  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D010  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D011  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D012  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D013  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D014  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D016  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D017  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D018  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D019  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D020  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D021  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D022  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D023  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D025  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D026  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D027  dyslexia  3  ${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_3_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C001  control  4  ${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C002  dyslexia  4  ${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C003  control  4  ${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C004  control  4  ${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C005  control  4  ${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C006  control  4  ${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C007  control  4  ${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C008  control  4  ${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C009  control  4  ${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C010  control  4  ${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C011  control  4  ${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C012  control  4  ${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C013  control  4  ${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C014  control  4  ${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C015  control  4  ${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C016  control  4  ${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C017  control  4  ${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C018  control  4  ${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C019  control  4  ${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C020  control  4  ${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C021  control  4  ${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C022  control  4  ${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C023  control  4  ${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D001  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D003  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D006  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D007  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D008  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D009  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D010  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D011  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D012  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D013  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D014  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D016  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D017  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D018  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D019  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D020  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D021  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D022  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D023  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D025  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D026  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D027  dyslexia  4  ${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_4_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C001  control  5  ${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C002  dyslexia  5  ${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C003  control  5  ${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C004  control  5  ${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C005  control  5  ${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C006  control  5  ${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C007  control  5  ${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C008  control  5  ${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C009  control  5  ${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C010  control  5  ${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C011  control  5  ${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C012  control  5  ${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C013  control  5  ${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C014  control  5  ${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C015  control  5  ${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C016  control  5  ${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C017  control  5  ${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C018  control  5  ${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C019  control  5  ${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C020  control  5  ${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C021  control  5  ${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C022  control  5  ${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C023  control  5  ${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D001  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D003  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D006  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D007  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D008  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D009  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D010  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D011  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D012  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D013  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D014  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D016  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D017  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D018  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D019  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D020  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D021  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D022  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D023  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D025  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D026  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D027  dyslexia  5  ${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_5_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C001  control  6  ${FUNC_DIR}/Luke_Nih_C001/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C002  dyslexia  6  ${FUNC_DIR}/Luke_Nih_C002/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C003  control  6  ${FUNC_DIR}/Luke_Nih_C003/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C004  control  6  ${FUNC_DIR}/Luke_Nih_C004/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C005  control  6  ${FUNC_DIR}/Luke_Nih_C005/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C006  control  6  ${FUNC_DIR}/Luke_Nih_C006/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C007  control  6  ${FUNC_DIR}/Luke_Nih_C007/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C008  control  6  ${FUNC_DIR}/Luke_Nih_C008/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C009  control  6  ${FUNC_DIR}/Luke_Nih_C009/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C010  control  6  ${FUNC_DIR}/Luke_Nih_C010/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C011  control  6  ${FUNC_DIR}/Luke_Nih_C011/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C012  control  6  ${FUNC_DIR}/Luke_Nih_C012/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C013  control  6  ${FUNC_DIR}/Luke_Nih_C013/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C014  control  6  ${FUNC_DIR}/Luke_Nih_C014/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C015  control  6  ${FUNC_DIR}/Luke_Nih_C015/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C016  control  6  ${FUNC_DIR}/Luke_Nih_C016/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C017  control  6  ${FUNC_DIR}/Luke_Nih_C017/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C018  control  6  ${FUNC_DIR}/Luke_Nih_C018/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C019  control  6  ${FUNC_DIR}/Luke_Nih_C019/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C020  control  6  ${FUNC_DIR}/Luke_Nih_C020/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C021  control  6  ${FUNC_DIR}/Luke_Nih_C021/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C022  control  6  ${FUNC_DIR}/Luke_Nih_C022/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_C023  control  6  ${FUNC_DIR}/Luke_Nih_C023/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D001  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D001/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D003  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D003/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D006  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D006/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D007  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D007/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D008  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D008/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D009  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D009/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D010  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D010/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D011  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D011/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D012  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D012/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D013  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D013/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D014  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D014/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D016  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D016/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D017  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D017/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D018  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D018/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D019  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D019/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D020  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D020/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D021  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D021/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D022  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D022/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D023  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D023/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D025  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D025/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D026  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D026/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'  \
	Luke_Nih_D027  dyslexia  6  ${FUNC_DIR}/Luke_Nih_D027/predictability/predictability_6_blur5_ANTS_resampled+tlrc'[3]'
