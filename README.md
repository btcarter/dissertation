# dissertation

This repository contains all the analysis scripts used for my dissertation, part of the NIH Dyslexia Study at BYU in Steven Luke's lab. Most of these scripts are an modification/extension of a previous analysis I completed as part of the [Skilled Reading Project] (https://github.com/btcarter/LinguisticPrediction). Check that out for additional details on the development if answers are not found here.

## Project status

incrementally testing structural scripts to map I/O on step1






## Organization and Analysis

### Scripts
Scripts are organized into directories based on two criteria: (1) computing environment and (2) data modality. Scripts stored in `local` were executed on a late 2013 iMac, OS 10.15.3. Scripts stored in `slurm` were executed on the Mary Lou Fulton Cluster, provided by Brigham Young University.

Analysis plan and scripts were executed in the order depicted in the table below. Additional explanation is included below as well.

| Step | Script | Output | Local or SLURM |
|------|--------|--------|----------------|
| Template Construction |
| HRF Construction |
| fMRI Preprocessing |
| fMRI Deconvolution |
| fMRI Group Results |
| Behavioral Data |
| Demographic |

### Template Construction

The following steps were performed to construct a structural template drawn from all study participants.

1. DICOMs were converted to NIFTI format.
2. NIFTIs were then AC-PC aligned.
3. AC-PC aligned out was then subjected to N4-Bias correction.

## Data

Data are stored elsewhere on a cloud service known as Box. I may make sample data available here in the future, but am planning on putting the entire dataset, including output on the [Open Science Framework] (https://osf.io/gjp4e/) (it's not publicly available yet).
