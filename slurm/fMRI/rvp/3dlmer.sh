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
Luke_Nih_C001
Luke_Nih_C002
Luke_Nih_C003
Luke_Nih_C004
Luke_Nih_C005
Luke_Nih_C006
Luke_Nih_C007
Luke_Nih_C008
Luke_Nih_C009
Luke_Nih_C010
Luke_Nih_C011
Luke_Nih_C012
Luke_Nih_C013
Luke_Nih_C014
Luke_Nih_C016
Luke_Nih_C017
Luke_Nih_C018
Luke_Nih_C019
Luke_Nih_C020
Luke_Nih_C021
Luke_Nih_C022
Luke_Nih_C023
Luke_Nih_D001
Luke_Nih_D003
Luke_Nih_D006
Luke_Nih_D007
Luke_Nih_D008
Luke_Nih_D009
Luke_Nih_D010
Luke_Nih_D011
Luke_Nih_D012
Luke_Nih_D013
Luke_Nih_D014
Luke_Nih_D015
Luke_Nih_D016
Luke_Nih_D017
Luke_Nih_D018
Luke_Nih_D019
Luke_Nih_D020
Luke_Nih_D021
Luke_Nih_D022
Luke_Nih_D023
Luke_Nih_D025
Luke_Nih_D026
Luke_Nih_D027
