# Summary

This repository contains all the analysis scripts used for my dissertation, part of the NIH Dyslexia Study at BYU in Steven Luke's lab. Most of these scripts are a modification/extension of a previous analysis I completed as part of the [Skilled Reading Project](https://github.com/btcarter/LinguisticPrediction). Check that out for additional details on the development if answers are not found here.

# Project status

Finished dissertation analysis and write up. Now working on other branches of the project to make it publishable. Hopefully more data is incoming but who knows with COVID? I'll be working on those other projects for now. If more data comes in then I may rerun this analysis.

# Organization and Analysis

## Scripts
Scripts are organized into directories based on two criteria: (1) computing environment and (2) data modality. Scripts stored in `local` were executed on a late 2013 iMac, OS 10.15.3. Scripts stored in `slurm` were executed on the Mary Lou Fulton Cluster, provided by Brigham Young University.

Analysis plan and scripts were executed in the order depicted in the table below. Additional explanation is included below as well.

| Step | Scripts | Output | Local or SLURM |
|------|--------|--------|----------------|
| Template Construction | slurm > structural > step1-5 | legion | SLURM |
| HRF Construction | /local/hrfET/make_hrfs.r | An event file per participant per event type | Local |
| fMRI Preprocessing | /slurm/fmri/preproc/preproc_job.sh | epi<1-5>_aligned+orig | SLURM |
| fMRI Deconvolution | /slurm/fmri/predictability/3dDeconvolve_pred_job.sh | predictability_deconv_blur5+orig | SLURM |
| fMRI Template alignment | /slurm/fmri/predictability/ants_trans_pred_job.sh | predictability_deconv_blur5_ANTS_resampled+tlrc | SLURM |
| fMRI Group Results | /slurm/fmri/predictability/3dttest_predMaskWhole_job.sh | Many | SLURM |
| Behavioral Data | /local/hrfET/make_hrfs.r | Figures and LaTeX formatted tables | Local |
| Demographic | /local/demographics/table1.R | Figures and LaTeX formatted tables | Local |

## Template Construction

The following steps were performed to construct a structural template drawn from all study participants.

1. DICOMs were converted to NIFTI format.
2. NIFTIs were then AC-PC aligned.
3. AC-PC aligned output was then subjected to N4-Bias correction.
4. Affine registration of N4BC output.
5. Images warped into MNI template space.
6. MNI aligned study template created.
7. Model is then subjected to segmentation via JLF.
8. Gray matter mask is then created using JLF output.

## Functional Analysis

1. Preprocessing
2. Deconvolution
3. Registration to template
4. T-test
5. ROI analysis

# Data

Data are stored elsewhere on a cloud service known as Box. I may make sample data available here in the future, but am planning on putting the entire dataset, including output on the [Open Science Framework](https://osf.io/gjp4e/) (it's not publicly available yet).
