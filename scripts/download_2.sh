#/usr/bin/env bash
# This script uses fasterq-dump to download SRA accessions listed in the input accession file !/usr/bin/env bash
cpus=24 country_data=../accessions/sra_accessions.txt 
for accession in $(cat $country_data | sed '1d') 
do
    echo "Creating directory for $accession"
    mkdir -pv ../raw_data/$accession
    echo "Successfully created directory for $accession"
    echo "Downloading $accession"
    prefetch $accession
    cd ../raw_data/$accession
    fastq-dump --outdir ./ --gzip $accession
    echo "Download of the sample ended"
    cd - # Return to the previous directory done
done
