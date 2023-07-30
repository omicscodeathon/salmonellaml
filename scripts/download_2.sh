#/usr/bin/env bash
# This script uses fasterq-dump to download SRA accessions listed in the input accession file !/usr/bin/env bash
# cpus=24 
# country_data=../accessions/sra_accessions.txt 
# for accession in $(cat $country_data | sed '1d') 
# do
#     echo "Creating directory for $accession"
#     mkdir -pv ../raw_data/$accession
#     echo "Successfully created directory for $accession"
#     echo "Downloading $accession"
#     prefetch $accession
#     cd ../raw_data/$accession
#     fastq-dump --outdir ./ --gzip $accession
#     echo "Download of the sample ended"
#     cd - # Return to the previous directory done
# done

#!/usr/bin/env bash

# Check if the folder argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

cpus=24
folder="$1"

# Loop through each 'sra_accessions.txt' file in the provided folder and its subfolders
for country_data in "$folder"/*sra_accessions.txt; do
    echo "Processing file: $country_data"

    # Loop through the accessions listed in the file
    while read -r accession; do
        # Skip the first line (if any) and any empty lines
        if [[ "$accession" == "Sample"* || -z "$accession" ]]; then
            continue
        fi

        echo "Creating directory for $accession"
        mkdir -pv "../raw_data/$accession"
        echo "Successfully created directory for $accession"

        echo "Downloading $accession"
        prefetch "$accession"
        fastq-dump --outdir "../raw_data/$accession" --gzip "$accession"
        echo "Download of the sample ended"
    done < <(tail -n +2 "$country_data")
done
