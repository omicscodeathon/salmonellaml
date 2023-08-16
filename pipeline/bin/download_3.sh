#!/usr/bin/env bash
input_file="$1"
output_directory="./"

accessions=($(cut -f2 "$input_file"))  # Extract second column and store in array

# Pass the array elements as separate arguments to fastq-dump
fastq-dump --outdir "$output_directory" --gzip  --split-3 "${accessions[@]}"
