#/usr/bin/env bash
# 1. extract biosmaple ID
python extract_biosample_ids_1.py ../data/biosample_data/
# 2. Extract SRA_iDs 
 bash sra_from_biosample_2.sh
 
# 3. Downlod the Data using the SRA Accesions
bash download_3.sh ../accessions/trial_accessions/

# Quality control
bash quality_control_4.sh
# Variant calling providing path to the trimmed data directory
bash vcf_pipeline_5.sh ../data/trimmed_data"


# NEXTFLOW
conda activate salmonella
nextflow run pipeline --folder_path data/biosample_data/