#!/bin/bash

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "reml"  # job name

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

HOME_DIR=/fslhome/ben88/compute/NihReadingStudy
FUNC_DIR=${HOME_DIR}/functional
MASK=${HOME_DIR}/masks/nctosaMask+tlrc
RES_DIR=${HOME_DIR}/dissertation/rvp

# 3dREML command
3dREMLfit -matrix rvp_deconv.xmat.1D \
 -input "${FUNC_DIR}/${1}/preproc/epi1_aligned+orig ${FUNC_DIR}/${1}/preproc/epi2_aligned+orig ${FUNC_DIR}/${1}/preproc/epi3_aligned+orig ${FUNC_DIR}/${1}/preproc/epi4_aligned+orig${FUNC_DIR}/${1}/preproc/epi5_aligned+orig ${FUNC_DIR}/${1}/preproc/epi6_volreg+orig" \
 -mask ${FUNC_DIR}/${1}/preproc/struct_mask+orig \
 -tout \
 -Rbuck rvp_deconv_REML \
 -Rvar rvp_deconv_REMLvar \
 -verb $*
