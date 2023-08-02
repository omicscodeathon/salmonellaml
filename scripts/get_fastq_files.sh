#!/usr/bin/env bash
## use biosample ids to collect Fastq files
fileids="../data/three_acc.txt"

# Iterate over each SRA identifier from the file
for row in $(cat $fileids); do
    # Fetch the SRA accession number associated with the identifier
    sra_id=$(esearch -db sra -query "$row" </dev/null | efetch -format docsum | xtract -pattern Runs -element Run@acc)

    # Download FASTQ data for the SRA accession number
    echo "Downloading $sra_id"
    fastq-dump -A "$sra_id" --split-files

done

