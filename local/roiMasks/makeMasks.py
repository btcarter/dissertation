#!/bin/python

# purpose: this script will use the Neurosynth Core tools to create masks for the eye fields, and the reading and langugae networks.

# import tools
from neurosynth import meta, decode, network

# set working directory
path="~/Box/LukeLab/NIH Dyslexia Study/data/neurosynth/"
os.chdir(path)

# load data
dataset = Dataset.load('dataset.pkl')   # Note the capital D in the second Dataset--load() is a class method

# make eye fields mask
ids = dataset.get_studies(features=['eye field*, (dlpfc | dorsolateral prefrontal*), (saccade | fixation)'], frequency_threshold=0.05) # get ids of studies with listed features.
print "Found %d studies for eyefields." len(ids)
ma = meta.MetaAnalysis(dataset, ids) # perform meta-analysis
ma.save_results('.', 'eyefields') # save nifti with results


# make eye fields mask
ids = dataset.get_studies(features=['read*, language & sentence, writ*'], frequency_threshold=0.05) # get ids of studies with listed features.
print "Found %d studies for reading." len(ids)
ma = meta.MetaAnalysis(dataset, ids) # perform meta-analysis
ma.save_results('.', 'reading') # save nifti with results
