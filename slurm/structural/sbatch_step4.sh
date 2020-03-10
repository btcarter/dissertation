#!/bin/bash


# Written by Nathan Muncy on 11/20/17
# Butchered by Ben Carter, 2019-04-09.


#SBATCH --time=50:00:00   # walltime
#SBATCH --ntasks=6   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16gb   # memory per CPU core
#SBATCH -J "step4Temp"   # job name
#SBATCH --mail-user=ben88@byu.edu  # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORK_DIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE


#######################
# --- ENVIRONMENT --- #
#######################

export ANTSPATH=/fslhome/ben88/apps/install/bin
PATH=${ANTSPATH}:${PATH}

WORK_DIR=~/compute/NihReadingStudy/template/construct
OASIS_DIR=~/templates/adult/OASIS-TRT-20_volumes
LABELS_DIR=~/templates/adult/OASIS-TRT-20_DKT31_CMA_labels_v2

####################
# --- COMMANDS --- #
####################
# ------------------
# OPERATIONS: these are performed once per participant as submitted.
# 1. Performs model segmentation and labeling via antsJointLabelFusion_fixed.sh
#
# REQUIRES: things needed to run this script
# 1. OASIS 20 atlas and labels (OASIS-TRT-20_volumes.tar.gz found at https://osf.io/tyvhs/) from the Mindboggle Project (https://osf.io/nhtur/), whole brain labels found at the Harvard Dataverse (https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/HMQKCK/L7WIGV&version=2.0).
# ------------------


cd $WORK_DIR

dim=3
out=${WORK_DIR}/JLF_
subj=${WORK_DIR}/nctosa_mni_template0.nii.gz
atlas=${OASIS_DIR}
labels=${LABELS_DIR}
parallel=5
cores=6
post=${WORK_DIR}/priors_JLF/label_%04d.nii.gz

if [ -f ${out}* ]
  then
    rm ${out}*
fi


~/apps/ANTs/Scripts/antsJointLabelFusion.sh \
-d ${dim} \
-t ${subj} \
-o ${out} \
-p ${post} \
-c ${parallel} \
-j ${cores} \
-q 0 \
-u 50:00:00 \
-v 16gb \
-w 50:00:00 \
-z 16gb \
-g ${atlas}/OASIS-TRT-20-1/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-1_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-2/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-2_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-3/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-3_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-4/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-4_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-5/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-5_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-6/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-6_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-7/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-7_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-8/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-8_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-9/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-9_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-10/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-10_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-11/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-11_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-12/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-12_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-13/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-13_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-14/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-14_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-15/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-15_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-16/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-16_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-17/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-17_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-18/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-18_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-19/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-19_DKT31_CMA_labels.nii.gz \
-g ${atlas}/OASIS-TRT-20-20/t1weighted.nii.gz -l ${labels}/OASIS-TRT-20-20_DKT31_CMA_labels.nii.gz
