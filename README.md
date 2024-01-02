# salmonellaml
Attributing the Source of Salmonella Enterica: A Machine Learning Approach to Understanding Pathogen Surveillance in Africa
## Table of Contents
- [Introduction](#Introduction)
- [Objectives](#Objectives)
- [Data](#Data)
- [Methods](#Methods)
- [Results](#Results)
- [Reproducibility](#Reproducibility)
- [Discussion](#Discussion)
- [Team](#Team)
- [Acknowledgment](#Acknowledgment)
- [References](#References)

## Introduction
Salmonella enterica is a pathogen that can be transmitted from animals to humans through food and is responsible for causing a considerable number of foodborne illnesses worldwide. These illnesses can manifest as gastrointestinal symptoms, fever, abdominal cramps, and, in severe cases, may lead to hospitalization and even deaths. While developed countries have made significant progress in reducing Salmonella infections through improved food safety practices and public health measures, it continues to pose a significant problem in low and middle-income countries. To address these challenges in resource-constrained settings, this project aims to utilize machine learning techniques to predict the sources of Salmonella outbreaks, with a specific focus on Africa. By combining data from various sources, including genomic data, epidemiological records, and environmental factors, the goal is to develop robust predictive models capable of identifying potential sources of Salmonella contamination. This approach could enable targeted interventions, leading to more effective prevention and control strategies.

## Objectives
1. Develop machine learning models to predict the source of Salmonella Enterica  based on whole genome sequencing data
2. Identify SNPs determinants associated with source attributions.
## Data
The data that was used in this study was obtained from ![NCBI isolate brower database](https://www.ncbi.nlm.nih.gov/pathogens/isolates#). The dataset used in the study is in ![accessions folder](http://34.29.100.237/user/onyangob/tree/my_shared_data_folder/salmonellaml/salmonellaml/accessions)




## Methods

![workflow](https://github.com/omicscodeathon/salmonellaml/blob/main/figures/workflow.png)

## Results
![results](https://github.com/omicscodeathon/salmonellaml/blob/main/output/dendrogram_accessions.png)
![results](https://github.com/omicscodeathon/salmonellaml/blob/main/figures/Model%20Performance_ROC_Evaluation.png)
![results](https://github.com/omicscodeathon/salmonellaml/blob/main/figures/ROCLightGBM.png)
![results](https://github.com/omicscodeathon/salmonellaml/blob/main/figures/precision_Recall.png)
![results](https://github.com/omicscodeathon/salmonellaml/blob/main/figures/Correct_Classification_graph.png)
![results](https://github.com/omicscodeathon/salmonellaml/blob/main/figures/Misclassification_graph.png)



## Reproducibility
The reproducibility documentation of this project can be found here 
![link](https://github.com/omicscodeathon/salmonellaml/blob/main/pipeline/REDME.md)
 
 ## Team
- Bonface Onyango
- Brenda Muthoni
- Asime Oba
- Oscar Nyangiri
- Olaitan Awe
