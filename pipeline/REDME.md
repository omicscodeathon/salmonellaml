# Salmonella Source Attribution Pipeline
This repository contains a Nextflow pipeline for Salmonella enterica source attribution. The pipeline processes input biosample data to extract biosample IDs, retrieve corresponding SRA accessions, download SRA data, and perform quality control using Fastp.
Repository Structure
- bin: Contains executable scripts to be run.
- modules: Contains Nextflow-defined processes for the pipeline.
- main: Contains the main Nextflow script that orchestrates the workflow
-configuration: contains configuratio set up for the pipeline

## Pipeline Steps
 A) Download- Quality Control
- 1. Extract Biosample IDs: The pipeline reads a TSV file containing biosample information and extracts biosample IDs using the EXTRACT_BIOSAMPLE_ID module.
- 2. Retrieve SRA Accessions: The biosample IDs are used to retrieve corresponding SRA accessions using the EXTRACT_SRA_IDS module, which utilizes an estractsra.sh script.
- 3. Download SRA Data: The SRA accessions are used to download corresponding SRA data using the DOWNLOAD module, which employs a download.sh script.
- 4. Quality Control: The downloaded SRA data is subjected to quality control using Fastp in the QUALITY_CONTROL module.

## Run the pipeline using the Nextflow script:

nextflow run pipeline --folder_path /path/to/tsv_directory

## Example usage
nextflow run pipeline/ --folder_path data/biosample_data/kenya/

## Variant calling 
The varian calling script takes in the path of trimmed data
  - Index the refrence genome
  - Do the Alignment of each read to reference genome and outpu bam fle foe next steps
  - Variant calling 
  - Ouput snp files for each sample for the next satage of generating a dataframe of genomic position in the columns and samples in rows
## Example usage
bash vcf_pipeline_5.sh path/to/trimmed_data 

