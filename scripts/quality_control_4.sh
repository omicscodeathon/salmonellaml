#!/bin/bash
input_dir="../data/raw_data/"
output_dir="../data/trimmed_data"
trimmomatic_exec="trimmomatic"

# Create output directory for trimmed data
mkdir -p "$output_dir"

# Loop through all files in the input directory
for file in "$input_dir"/*_R1.fastq.gz; do
    forward_file="$file"
    reverse_file="${file/_R1.fastq.gz/_R2.fastq.gz}"

    # Check if both forward and reverse files exist for this pair
    if [ -f "$reverse_file" ]; then
        # If both files exist, use Trimmomatic for paired-end data
        sample_name=$(basename "$forward_file" _R1.fastq.gz)
        $trimmomatic_exec PE -threads 4 "$forward_file" "$reverse_file" \
            "$output_dir/$sample_name/output_R1_paired.fastq.gz" "$output_dir/$sample_name/output_R1_unpaired.fastq.gz" \
            "$output_dir/$sample_name/output_R2_paired.fastq.gz" "$output_dir/$sample_name/output_R2_unpaired.fastq.gz" \
            ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    else
        # If reverse file is missing, use Trimmomatic for single-end data
        sample_name=$(basename "$forward_file" _R1.fastq.gz)
        $trimmomatic_exec SE -threads 4 "$forward_file" \
            "$output_dir/$sample_name/output_R1_unpaired.fastq.gz" \
            ILLUMINACLIP:TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    fi
done
