# Artifact: Practical Automated Detection of Malicious npm Packages

This repository contains the artifact accompanying our ICSE '22 paper "Practical Automated Detection of Malicious npm Packages", which presents an approach to automatically detecting malicious npm packages based on a combination of three components: machine-learning classifiers trained on known samples of malicious and benign npm packages; a reproducer for identifying packages that can be rebuilt from source and hence are unlikely to be malicious; and a clone detector for finding copies of known malicious packages.

The artifact contains the code for training the classifiers and a description of the samples used for initial training, as well as input data and results for the two experiments reported in the paper: classifying and retraining on newly published packages over the course of one week (Section 4.1), and classifying manually labeled packages (Section 4.2). We further explain where to find this data in the repository below.

The artifact does _not_ contain the feature-extraction code, the contents and features of the training samples, the trained classifiers, and the contents and features of the samples considered in our experiments. We further explain why these could not be included below.

## What is included

### Code for training classifiers

This is implemented as a Python script [training-code/train_classifier.py](training-code/train_classifier.py). Invoking the script with the `--help` option prints out an explanation of the various supported command-line flags. Note that this code is for reference purposes only and cannot be used to replicate our results, since it needs as its input features for the samples comprising the training set, which are not included in the artifact as explained below.

### Description of basic corpus

The CSV file [data/basic-corpus.csv](data/basic-corpus.csv) lists information about the samples constituting the basic corpus our classifiers were trained on (Section 3.3). For each sample, it contains the _package_ name and _version_ number of the npm package it corresponds to, the _hash_ of the sample (computed as described in Section 3.4), and an _analysis_ label indicating whether the sample is malicious or benign.

### Input data for experiments

The CSV files [data/july-29.csv](data/july-29.csv) to [data/august-4.csv](data/august-4.csv) list information about the samples considered in Experiment 1, corresponding to all new package versions published to the npm registry that day, excluding private packages. The format is the same as for the training set, but samples that were not manually reviewed are labeled as "not triaged".

Taken together, these files total about 8.3MB of data.

### Results of experiments

The directory [results/slide-window](results/slide-window) contains the results of Experiment 1, again in a series of CSV files named [july-29.csv](results/slide-window/july-29.csv) to [august-4.csv](results/slide-window/august-4.csv). For each day, it lists each sample that was labeled as malicious by at least one classifier or the clone detector. For each sample, we again list _package_ name, _version_, and _hash_ as above; whether the sample was _reproducible_ from source by the reproducer; whether the sample was found to be malicious or not by manual _analysis_, and whether each of the classifiers (_decision-tree_, _naive-bayes_, _svm_, _hash_) labeled it as malicious.

The directory [results/cross-validation](results/cross-validation) contains the result from the 10-fold cross-validation on our basic corpus data performed as part of Experiment 2, with one subdirectory per fold. For each fold, there are three TSV files, one per classifier, with three columns: package name, package version, and the label assigned by the classifier.

Finally, the directory [results/maloss](results/maloss) contains the results from running our classifiers on the MalOSS dataset from Duan et al.'s paper "Towards Measuring Supply Chain Attacks on Package Managers for Interpreted Languages". As for the cross-validation experiment, there is one TSV file per classifier, with the same three columns as above.

Taken together, these files total about 0.6MB of data. 

## What is not included

## Contents of samples

We were not able to include the contents of the samples in our basic corpus or the samples considered in Experiment 1, since some of them contain malicious and harmful code.

## Features of samples

We were not able to include the features extracted from the samples either. Our approach might be deployed in production at some future date, and we do not want to give a prospective attacker any support in reverse-engineering our technique so as to avoid detection.

## Code for extracting features

For the same reason, we were not able to include the feature-extraction code.

## Trained classifiers

Finally, the classifiers trained on the basic corpus and as part of Experiment 1 can, unfortunately, also not be made public, again due to concerns about abuse by malicious parties.
