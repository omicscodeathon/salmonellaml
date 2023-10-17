# Salmonella Source Attribution Pipeline
This repository contains a reproducibility steps for Salmonella enterica source attribution. The pipeline processes input biosample data to extract biosample IDs, retrieve corresponding SRA accessions, download SRA data, and perform quality control using Fastp.The downloaded data is followed by running the notebooks in this oeder; 1) preprocessing_01.ipynb2) dimentionality_reduction_2_updated.ipynb 3) Hyperparameter_Tuning_machine_learning_3.ipynb and 4) processing_test_dataset_4.ipynb

# Setting up environment
The package requirements for this project are in the requirements file.

conda env create --name <environment_name> --file <input_file.yml>
example usage
```
conda env create --salmonellaml --file ../requirements.yml
```
```
conda activate salmonellaml
```
# Reproducibility  Steps
The diagram below shows the data input staructures fpr each of the scriots upto the generation of a table with samples in columns and genomic position of SNps in the columns.
![ Illustration of Scripts Data Input and Output from Data Acquistion to table generation](https://github.com/omicscodeathon/salmonellaml/blob/main/figures/preprocesing_illustration_scripts_excecution.png)

## Data Download and prepcessing
- Download reference sequence

```
wget -O ./data/salmonellaref.fasta https://www.ncbi.nlm.nih.gov/nuccore/NZ_JAPQLD010000001.1
```

- Process tha metadata tables for each country from the accessions folder. The data was downloaded by country and deleteting internedfiate files to free memmory
 
- A) Extract Biosample IDs (extract_biosample_ids_1.py): The  python script reads a TSV file containing biosample information and extracts biosample IDs using the.

- B) Retrieve SRA Accessions (sra_from_biosample_2.sh): The biosample IDs are used to retrieve corresponding SRA accessions using the extratcted Biosample ID 

- C) Download SRA Data (download_3.sh): The SRA accessions are used to download corresponding SRA data using the DOWNLOAD module, which employs a download.sh script.
Above steps can be achieved 

nextflow run pipeline --folder_path /path/to/tsv_directory

### Example usage
The following code downloads and preprocess data for Kenya. The code will ouput foward and recerse sequence data that can be used to call  variants using  another script. 

```
nextflow run pipeline/ --folder_path accessions/kenya/
```

### Variant calling 
The varian calling script takes in the path of trimmed data
  - Index the refrence genome
  - Do the Alignment of each read to reference genome and outpu bam fle foe next steps
  - Variant calling 
  - Ouput snp files for each sample for the next satage of generating a dataframe of genomic position in the columns and samples in rows
### Example usage
bash vcf_pipeline_5.sh ../data/trimmed_data

### Master script
The master script (scripts_all.sh) contains the multiple scipts that can be executed to download the data and perform variant calling for a given country . The command below shows how to process data for Kenya. This will output the snps data in the folder bearing the name provided in the script
```
bash all_scripts.sh ../accessions/kenya/
```
## Jupyter Notebooks
A) preprocessing of the SNP data (preprocessing_01.ipynb). This notebook was used to mearge all the SNPs for each country, comibining the metadata, and assigning category to each sample to the four sources (human, bovine,swine,poultry)for downstream analysis

A) Dimentionality Reduction (dimentionality_reduction_2_updated.ipynb): SNPs data produces hundresd od thousands of SNPs. This notebook was used to extract top 100 SNPs using ChiSquare approach, identiying the correlation among the SNPs and removing atleast one pair of highly correlted SNPs resulting to  49 features (SNPs) 

C) Machine learning (Hyperparameter_Tuning_machine_learning_3.ipynb): This script was used for tuning the parameters for the machine learning models, training the dataset and evaluating the model perfoemances
