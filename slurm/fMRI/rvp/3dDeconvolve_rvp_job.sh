#!/bin/sh

#SBATCH --time=06:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16384M  # memory per CPU core
#SBATCH -J "decon"  # job name

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
	subj_DIR=${HOME_DIR}/functional/${1}
	TIMING=${HOME_DIR}/hrfs
				TIMING_READ=${TIMING}/block_read/${1}.txt
				TIMING_PIC=${TIMING}/block_pictures/${1}.txt
LOG=/fslhome/ben88/logfiles

##########
#COMMANDS#
##########

#  Created by Benjamin Carter on 03/20/2017.
#  This script performs Ordinary Least Square Regression of subject data using 3dDeconvolve from the AFNI software package.


cd $subj_DIR

if [ ! -d rvp ]
    then
        mkdir rvp
fi

cd rvp

#####################
#REGRESSION ANALYSIS#
#####################



if [ -f $TIMING_POS ] && [ ! -f rvp_deconv+orig.BRIK ]
    then
			echo "I decided to run"
        #3dDeconvolve
        ${AFNI_BIN}/3dDeconvolve \
            -input \
						$subj_DIR/preproc/epi1_aligned+orig \
						$subj_DIR/preproc/epi2_aligned+orig \
						$subj_DIR/preproc/epi3_aligned+orig \
						$subj_DIR/preproc/epi4_aligned+orig \
						$subj_DIR/preproc/epi5_aligned+orig \
						$subj_DIR/preproc/epi6_volreg+orig \
            -mask $subj_DIR/preproc/struct_mask+orig \
            -polort A \
            -num_stimts 7 \
            -stim_file 1 "$subj_DIR/motion/motion.txt[0]" -stim_label 1 "Roll"  -stim_base   1 \
            -stim_file 2 "$subj_DIR/motion/motion.txt[1]" -stim_label 2 "Pitch" -stim_base   2 \
            -stim_file 3 "$subj_DIR/motion/motion.txt[2]" -stim_label 3 "Yaw"   -stim_base   3 \
            -stim_file 4 "$subj_DIR/motion/motion.txt[3]" -stim_label 4 "dS"    -stim_base   4 \
            -stim_file 5 "$subj_DIR/motion/motion.txt[4]" -stim_label 5 "dL"    -stim_base   5 \
            -stim_file 6 "$subj_DIR/motion/motion.txt[5]" -stim_label 6 "dP"    -stim_base   6 \
						-stim_times 7 ${TIMING_READ} 'BLOCK(12)' -stim_label 7 "READ" \
            -num_glt 1 \
            -gltsym 'SYM: READ' \
            -glt_label 1 READ \
            -censor "$subj_DIR/motion/motion_censor_vector.txt[0]" \
            -nocout -tout \
            -bucket rvp_deconv \
            -xjpeg rvp_design.jpg \
            -jobs 2 \
            -GOFORIT 12
fi



#blur the output of the regression analysis
if [ -f rvp_deconv+orig.BRIK ] && \
[ ! -f rvp_deconv_blur5+orig.BRIK ]
    then
			echo "I found something to blur"
        ${AFNI_BIN}/3dmerge -prefix rvp_deconv_blur5 -1blur_fwhm 5.0 -doall rvp_deconv+orig
fi
