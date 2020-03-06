#!/bin/python

# this script will load the dataset to be used for mask creation from Neurosynth. This should only be run once in a great while.

import os

os.chdir(r"/Users/ben88/Downloads/ns")

import neurosynth as ns
ns.dataset.download(path="/Users/ben88/Downloads/ns", unpack=True)

# Core functionality for managing and accessing data
from neurosynth import Dataset
# Analysis tools for meta-analysis, image decoding, and coactivation analysis
from neurosynth import meta, decode, network

# Downloand datatset for mask creation
# Create a new Dataset instance
dataset = Dataset('database.txt')

# Add some features
dataset.add_features('features.txt')

dataset.save('dataset.pkl')
