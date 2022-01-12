# amalfi-artifact
This is the repository containing the artifact for our ICSE '22 paper "Practical Automated Detection of Malicious npm Packages". 

The repository consists of three directories, whose contents are explained below. 

- 'data' directory:
  In our paper, we conducted three separate sets of experiments: a cross validation one, a sliding window one, and maloss experiments using data collected from a previous
  relavant research work. 
  This directory contains information about all the data used for the first two sets of our experiments. The  
  cross validation experiment used a corpus of data named the basic corpus, and all the information about that corpus is located in the basic-corpus.csv. 
  The rest of the files, each named after a date, pertain to the sliding window experiment, which consisted of collecting data for an entire week (July 29 to August 4);
  Each file contains information about the npm packages used in our experiments categorized in the following columns: 
  - Column **package** contains the name of the package 
  - Column **version** contains the official npm package version corresponding to the update we considered in our experiments 
  - Column **hash** contains a hash of the particular update contents minus any unique identifiers of the update such as the name and version
  - Column **analysis** contains the malicious status of a particular update, i.e., whether it is malicious or benign. The 'not triaged' cases refer to instances 
    where the contents of the package update have not been investigated. 
 
  The whole 'data' directory takes 8.3 MB of space. Because the data used in our dataset contains malicious and harmful code, we are not able to release the           contents of the package updates. 
 
 - 'results' directory: 
   This directory contains the results from the above-mentioned sets of experiments. We ran three different classifiers, a decision tree, Naive Bayes, and 
   one class SVM in each of these experiments. 
   
   Each subdirectory contains results for one set of experiments.  
   - The 'cross-validation' subdirectory contains the result from a 10-fold cross-validation in our basic corpus data. The subdirectories in the directory each pertain 
     to one of the folds. Inside each directory, there are three files, one per classifier, with three columns: package name, package version, and the label from the classifier. 
   - The 'maloss' subdirectory contains the results from the run of the three classifiers, in separate files, on the maloss dataset. The columns in each file 
     refer to the package name, version, and the label obtained from the classifier. 
   - The 'slide-window' subdirectory contains files with packages at least one of the classifiers has labeled as malicious. In addition to the three above mentioned 
      classifiers, we also used a special classifier using package hashes. Each file has metadata about the package update (package name, version, and hash), 
      whether the package is reprodubile from source (reproducible), whether the update was found to be malicious or not (analysis) and whether each of
      the classifiers (decision-tree, naive-bayes, svm, hash) has labeled it as malicious. 
      
   This directory takes 590KB of space. 
 
 - 'training-code' directory: 
    This directory contains the code we used to train our models based on the three ML classifiers we used. The main code is a python script named        train_classifier.py that takes up to 14 arguments. The format and meaning of aach argument is described in the code itself (lines 193-223). 
    
  
