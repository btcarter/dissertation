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
HOME_DIR=/fslhome/ben88/compute_dir/NihReadingStudy
	subj_DIR=${HOME_DIR}/functional/${1}
	TIMING=${HOME_DIR}/hrfs
				TIMING_PICS=$TIMING/block_pictures/${1}.txt
        TIMING_ORTHO=$TIMING/OrthoMatchModel/${1}.txt
				PICS=$TIMING/block_pictures_by_run/${1}_PICS
				ORTHO=$TIMING/OrthoMatchModel_by_run/${1}_ORTHO
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

if [ ! -d $TIMING/block_pictures_by_run ]
	then
		mkdir -p $TIMING/block_pictures_by_run $TIMING/OrthoMatchModel_by_run
fi

cd predictability

#####################
#REGRESSION ANALYSIS#
#####################

if [ -f $TIMING_POS ] && [ ! -f predictability.xmat.1D ]
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
            -num_stimts 8 \
            -stim_file 1 "$subj_DIR/motion_censors/motion.txt[0]" -stim_label 1 "Roll"  -stim_base   1 \
            -stim_file 2 "$subj_DIR/motion_censors/motion.txt[1]" -stim_label 2 "Pitch" -stim_base   2 \
            -stim_file 3 "$subj_DIR/motion_censors/motion.txt[2]" -stim_label 3 "Yaw"   -stim_base   3 \
            -stim_file 4 "$subj_DIR/motion_censors/motion.txt[3]" -stim_label 4 "dS"    -stim_base   4 \
            -stim_file 5 "$subj_DIR/motion_censors/motion.txt[4]" -stim_label 5 "dL"    -stim_base   5 \
            -stim_file 6 "$subj_DIR/motion_censors/motion.txt[5]" -stim_label 6 "dP"    -stim_base   6 \
						-stim_times 7 ${TIMING_PICS} 'BLOCK(12)' -stim_label 7 "PICS" \
            -stim_times_AM1 8 ${TIMING_ORTHO} 'dmBLOCK' -stim_label 8 "ORTHO" \
            -num_glt 3 \
            -gltsym 'SYM: PICS' \
            -glt_label 1 PICS \
            -gltsym 'SYM: ORTHO' \
            -glt_label 2 ORTHO \
            -gltsym 'SYM: ORTHO -PICS' \
            -glt_label 3 O-P \
            -censor "$subj_DIR/motion_censors/motion_censor_vector.txt[0]" \
            -nocout -tout \
            -bucket predictability \
            -xjpeg predictability_design.jpg \
            -jobs 2 \
            -GOFORIT 12
fi

# deconvolve and set up a reml for all the individual runs

if [ -f $TIMING_POS ] && [ ! -f predictability_1.xmat.1D ]
    then
			echo "I decided to run"
			for run in $(seq 5); do
				#select the hrf for the run
				sed -n ${run}p ${TIMING_PICS} > ${PICS}_${run}.txt
				sed -n ${run}p ${TIMING_ORTHO} > ${ORTHO}_${run}.txt
				#3dDeconvolve
				${AFNI_BIN}/3dDeconvolve \
            -input \
						$subj_DIR/preproc/epi${run}_aligned+orig \
            -mask $subj_DIR/preproc/struct_mask+orig \
            -polort A \
            -num_stimts 8 \
            -stim_file 1 "$subj_DIR/motion/motion_${run}.txt[0]" -stim_label 1 "Roll"  -stim_base   1 \
            -stim_file 2 "$subj_DIR/motion/motion_${run}.txt[1]" -stim_label 2 "Pitch" -stim_base   2 \
            -stim_file 3 "$subj_DIR/motion/motion_${run}.txt[2]" -stim_label 3 "Yaw"   -stim_base   3 \
            -stim_file 4 "$subj_DIR/motion/motion_${run}.txt[3]" -stim_label 4 "dS"    -stim_base   4 \
            -stim_file 5 "$subj_DIR/motion/motion_${run}.txt[4]" -stim_label 5 "dL"    -stim_base   5 \
            -stim_file 6 "$subj_DIR/motion/motion_${run}.txt[5]" -stim_label 6 "dP"    -stim_base   6 \
						-stim_times 7 ${PICS}_${run}.txt 'BLOCK(12)' -stim_label 7 "PICS" \
            -stim_times_AM1 8 ${ORTHO}_${run}.txt 'dmBLOCK' -stim_label 8 "ORTHO" \
            -num_glt 3 \
            -gltsym 'SYM: PICS' \
            -glt_label 1 PICS \
            -gltsym 'SYM: ORTHO' \
            -glt_label 2 ORTHO \
            -gltsym 'SYM: ORTHO -PICS' \
            -glt_label 3 O-P \
            -censor "$subj_DIR/motion_censors/motion_censor_vector_${run}.txt[0]" \
            -nocout -tout \
            -bucket predictability_${run} \
            -xjpeg predictability_${run}_design.jpg \
            -jobs 2 \
            -GOFORIT 12
			done

				run=6

				sed -n ${run}p ${TIMING_PICS} > ${PICS}_${run}.txt
				sed -n ${run}p ${TIMING_ORTHO} > ${ORTHO}_${run}.txt
				#3dDeconvolve
				${AFNI_BIN}/3dDeconvolve \
						-input \
						$subj_DIR/preproc/epi${run}_volreg+orig \
						-mask $subj_DIR/preproc/struct_mask+orig \
						-polort A \
						-num_stimts 8 \
						-stim_file 1 "$subj_DIR/motion/motion_${run}.txt[0]" -stim_label 1 "Roll"  -stim_base   1 \
						-stim_file 2 "$subj_DIR/motion/motion_${run}.txt[1]" -stim_label 2 "Pitch" -stim_base   2 \
						-stim_file 3 "$subj_DIR/motion/motion_${run}.txt[2]" -stim_label 3 "Yaw"   -stim_base   3 \
						-stim_file 4 "$subj_DIR/motion/motion_${run}.txt[3]" -stim_label 4 "dS"    -stim_base   4 \
						-stim_file 5 "$subj_DIR/motion/motion_${run}.txt[4]" -stim_label 5 "dL"    -stim_base   5 \
						-stim_file 6 "$subj_DIR/motion/motion_${run}.txt[5]" -stim_label 6 "dP"    -stim_base   6 \
						-stim_times 7 ${PICS}_${run}.txt 'BLOCK(12)' -stim_label 7 "PICS" \
						-stim_times_AM1 8 ${ORTHO}_${run}.txt 'dmBLOCK' -stim_label 8 "ORTHO" \
						-num_glt 3 \
						-gltsym 'SYM: PICS' \
						-glt_label 1 PICS \
						-gltsym 'SYM: ORTHO' \
						-glt_label 2 ORTHO \
						-gltsym 'SYM: ORTHO -PICS' \
						-glt_label 3 O-P \
						-censor "$subj_DIR/motion_censors/motion_censor_vector_${run}.txt[0]" \
						-nocout -tout \
						-bucket predictability_${run} \
						-xjpeg predictability_${run}_design.jpg \
						-jobs 2 \
						-GOFORIT 12
fi


# 3dREML command edit and submit to the super
bash predictability.REML_cmd -GOFORIT 12
bash predictability_1.REML_cmd -GOFORIT 12
bash predictability_2.REML_cmd -GOFORIT 12
bash predictability_3.REML_cmd -GOFORIT 12
bash predictability_4.REML_cmd -GOFORIT 12
bash predictability_5.REML_cmd -GOFORIT 12
bash predictability_6.REML_cmd -GOFORIT 12

#blur the output of the regression analysis
if [ -f predictability+orig.BRIK ] && \
	[ ! -f predictability_blur5+orig.BRIK ]
    then
			echo "I found something to blur"
        ${AFNI_BIN}/3dmerge -prefix predictability_blur5 -1blur_fwhm 5.0 -doall predictability+orig
fi

if [ -f predictability_REML+orig.BRIK ] && \
	[ ! -f predictability_REML_blur5*.BRIK ]
    then
			echo "I found something to blur"
        ${AFNI_BIN}/3dmerge -prefix predictability_REML_blur5 -1blur_fwhm 5.0 -doall predictability_REML+orig
fi

for run in $(seq 6); do
	if [ -f predictability_${run}_REML+orig.BRIK ] && \
		[ ! -f predictability_${run}_REML_blur5*.BRIK ]
	    then
				echo "I found something to blur"
	        ${AFNI_BIN}/3dmerge -prefix predictability_${run}_REML_blur5 -1blur_fwhm 5.0 -doall predictability_${run}_REML+orig
	fi
done
