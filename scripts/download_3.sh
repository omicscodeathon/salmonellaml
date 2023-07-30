#/usr/bin/env bash
# This script uses fasterq-dump to download SRA accessions listed in the input accession file !/usr/bin/env bash
# cpus=24 
input_directory="../accessions/trial_accessions"
output_directory="../data/raw_data"
for file in $(ls $input_directory/*.txt) 
do
for accession in $(cat $file) 

do
#     echo "processing  $accession"
#     mkdir -pv ../raw_data/$accession
#     echo "Successfully created directory for $accession"
    echo "Downloading $accession"
    prefetch $accession
#     cd ../raw_data/$accession
    fastq-dump --outdir $output_directory --gzip $accession
    echo "Download of the sample ended"
    cd - # Return to the previous directory done
done
done
# cpus=24
# input_directory="../accessions/trial_accessions"
# output_directory="../data/raw_data"

# # Function to download data for a single accession
# function download_accession_data() {
#     local accession=$1
#     echo "Downloading $accession"
#     prefetch $accession
#     fastq-dump --outdir "$output_directory" --gzip $accession
#     echo "Download of the sample ended"
# }

# # Loop through each file in the input directory
# for accession_file in "$input_directory"/*.txt; do
#     # Get the file name without the path and extension
#     file_name=$(basename "$accession_file" .txt)
    
#     # Echo the file name before processing
#     echo "Processing file: $file_name"

#     # Loop through each accession in the file
#     while IFS= read -r accession; do
#         if [[ -n "$accession" ]]; then
#             download_accession_data "$accession"
#         fi
#     done < "$accession_file"
# done

echo "All downloads completed!"
