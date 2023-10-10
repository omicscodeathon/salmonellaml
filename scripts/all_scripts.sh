#/usr/bin/env bash
# Data download
country=$1
echo "Downloading data started at $(date)"
nextflow run ../pipeline/ --folder_path ../accessions/$country
echo "Downloading data started at $(date)"
# Quality control based on downloaded data 
echo "Perforning Quality control satsetred at $(date)"
bash quality_control_fastp_4a.sh ../pipeline/run_salmonellaml
# Variant calling providing path to the trimmed data directory
echo "Perforning Quality control ended at $(date)"
echo "Calling variant started at $(date)"
bash vcf_pipeline_5.sh ../data/trimmed_data
echo "Calling variant ended at $(date)"
