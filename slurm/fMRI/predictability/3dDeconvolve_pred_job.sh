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
        TIMING_POS=$TIMING/POSMatchModel/${1}.txt
        TIMING_LSA=$TIMING/LSA_Context_Score/${1}.txt
        TIMING_ORTHO=$TIMING/OrthoMatchModel/${1}.txt
				TIMING_PIC=${TIMING}/block_pictures/${1}.txt
LOG=/fslhome/ben88/logfiles

##########
#COMMANDS#
##########

#  Created by Benjamin Carter on 03/20/2017.
#  This script performs Ordinary Least Square Regression of subject data using 3dDeconvolve from the AFNI software package.


cd $subj_DIR

if [ ! -d predictability ]
    then
        mkdir predictability
fi

cd predictability

#####################
#REGRESSION ANALYSIS#
#####################



if [ -f $TIMING_POS ] && [ ! -f predictability_deconv+orig.BRIK ]
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
            -num_stimts 10 \
            -stim_file 1 "$subj_DIR/motion/motion.txt[0]" -stim_label 1 "Roll"  -stim_base   1 \
            -stim_file 2 "$subj_DIR/motion/motion.txt[1]" -stim_label 2 "Pitch" -stim_base   2 \
            -stim_file 3 "$subj_DIR/motion/motion.txt[2]" -stim_label 3 "Yaw"   -stim_base   3 \
            -stim_file 4 "$subj_DIR/motion/motion.txt[3]" -stim_label 4 "dS"    -stim_base   4 \
            -stim_file 5 "$subj_DIR/motion/motion.txt[4]" -stim_label 5 "dL"    -stim_base   5 \
            -stim_file 6 "$subj_DIR/motion/motion.txt[5]" -stim_label 6 "dP"    -stim_base   6 \
						-stim_times 7 ${TIMING_PIC} 'BLOCK(12)' -stim_label 7 "PICS" \
            -stim_times_AM2 8 ${TIMING_POS} 'dmBLOCK' -stim_label 8 "POS" \
            -stim_times_AM2 9 ${TIMING_LSA} 'dmBLOCK' -stim_label 9 "LSA" \
            -stim_times_AM2 10 ${TIMING_ORTHO} 'dmBLOCK' -stim_label 10 "ORTHO" \
            -num_glt 3 \
            -gltsym 'SYM: POS' \
            -glt_label 1 POS \
            -gltsym 'SYM: LSA' \
            -glt_label 2 LSA \
            -gltsym 'SYM: ORTHO' \
            -glt_label 3 ORTHO \
            -censor "$subj_DIR/motion/motion_censor_vector.txt[0]" \
            -nocout -tout \
            -bucket predictability_deconv \
            -xjpeg predictability_design.jpg \
            -jobs 2 \
            -GOFORIT 12
fi



#blur the output of the regression analysis
if [ -f predictability_deconv+orig.BRIK ] && \
[ ! -f predictability_deconv_blur5+orig.BRIK ]
    then
			echo "I found something to blur"
        ${AFNI_BIN}/3dmerge -prefix predictability_deconv_blur5 -1blur_fwhm 5.0 -doall predictability_deconv+orig
fi
