#!/bin/bash

# Originally written by Nathan Muncy on 11/20/17.
# Butchered by Ben Carter, 2020-02-06.

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32gb   # memory per CPU core
#SBATCH -J "step1"   # job name
#SBATCH --mail-user=ben88@byu.edu  # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_TEMPLATE_DIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

#######################
# --- ENVIRONMENT --- #
#######################

START_DIR=${pwd} 											# in case you want an easy reference to return to the directory you started in.
STUDY=~/compute/NihReadingStudy					    	# location of study directory
TEMPLATE_DIR=${STUDY}/template 								# destination for template output
DICOM_DIR=${STUDY}/dicomdir/${1}						# new location of raw dicoms for participant
DICOM_DIR_orig=${DICOM_DIR}/Research_Luke*  # original structure of dicoms
SCRIPT_DIR=~/analyses/dissertation/structural				# location of scripts that might be referenced; assumed to be separate from the data directory.
PARTICIPANT_STRUCT=${STUDY}/structural/${1}					# location of derived participant structural data
D2N=~/apps/dcm2niix/bin/dcm2niix							# path to dcm2niix
ACPC=~/apps/art/acpcdetect									# path to acpcdetect
N4BC=~/apps/ants/install/bin/N4BiasFieldCorrection					# path to N4BiasFieldCorrection

####################
# --- COMMANDS --- #
####################
# ------------------
# OPERATIONS: these are performed once per participant as submitted.
# 1. NIFTIs are created from the native DICOMS
# 2. NIFTIs are ACPC aligned
# 3. N4Bias corrections are performed.
# ------------------

# 1. Create NIFTI files from the DICOMs
# check for BIDS structure in dicoms
if [ -d ${DICOM_DIR}/t1_* ];
then
	echo "found the scans I was looking for"
# try to rearrange dicom folder structure into BIDS compliance
elif [ -d ${DICOM_DIR_orig} ]; then
		echo "had to rearrange the dicom directory structure"
		mv ${DICOM_DIR_orig}/* ${DICOM_DIR}/
		rm ${DICOM_DIR_orig}
else
	echo "I did not find anything to process."
	exit 1
fi

# make a place to put the NIFTI files
if [ ! -d ${PARTICIPANT_STRUCT} ];
then
	mkdir -p ${PARTICIPANT_STRUCT}
else
	echo ${PARTICIPANT_STRUCT} already exists
fi

# make NIFTI files
if [ ! -f ${PARTICIPANT_STRUCT}/${1}_T1w.nii ];
then
	${D2N} \
	-z n \
	-x y \
	-o ${PARTICIPANT_STRUCT} \
	-i ${DICOM_DIR}
	mv ${PARTICIPANT_STRUCT}/*Crop*.nii ${PARTICIPANT_STRUCT}/${1}_T1w.nii
	rm core*
else
	echo ${PARTICIPANT_STRUCT}/${1}_T1w.nii already exists
fi

sleep 1

# 2. Perform ACPC alignment
if [ ! -f ${PARTICIPANT_STRUCT}/${1}_T1w_acpc.nii ];
then
	${ACPC} \
	-M \
	-o ${PARTICIPANT_STRUCT}/${1}_T1w_acpc.nii \
	-i ${PARTICIPANT_STRUCT}/${1}_T1w.nii
else
	echo ${PARTICIPANT_STRUCT}/${1}_T1w_acpc.nii already exists
fi

sleep 1

# 3. Perform N4-Bias Correction
DIM=3
ACPC=${PARTICIPANT_STRUCT}/${1}_T1w_acpc.nii
N4=${PARTICIPANT_STRUCT}/${1}_T1w_n4bc.nii.gz

CON=[50x50x50x50,0.0000001]
SHRINK=4
BSPLINE=[200]

if [ ! -f $N4 ];
then
	${N4BC} \
	-d $DIM \
	-i $ACPC \
	-s $SHRINK \
	-c $CON \
	-b $BSPLINE \
	-o $N4
else
	echo $N4 already exists
fi

if [ ! -f $N4 ];
then
	echo "something died, please do a postmortem"
	exit 1
fi
