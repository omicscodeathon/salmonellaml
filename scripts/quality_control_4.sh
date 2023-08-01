#!/bin/bash

input_dir="../data/raw_data"
output_dir="../data/trimmed_data"
trimmomatic_exec="trimmomatic"

# Create output directory for trimmed data
mkdir  $output_dir

# trimmomatic PE -threads 4 ../data/raw_data/SRR15279127_1.fastq.gz  ../data/raw_data/SRR15279127_2.fastq.gz output_R1_unpaired.fastq.gz   output_R2_paired.fastq.gz output_R2_unpaired.fastq.gz   LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
#!/bin/bash

input_dir="../data/raw_data"
output_dir="../data/trimmed_data"
trimmomatic_exec="trimmomatic"
threads=4
phred_option="-phred33" # Modify this to -phred64 if your data uses Phred64 quality scores

# Create output directory for trimmed data
mkdir -p "$output_dir"

# Loop through all files in the input directory
for file in "$input_dir"/*_1.fastq.gz; do
    echo "$file"

    forward_file=$file
    reverse_file=${file/_1.fastq.gz/_2.fastq.gz}
    echo "Processing $forward_file and $reverse_file"

    # Check if both forward and reverse files exist for this pair
    if [ -f "$reverse_file" ]; then
        # If both files exist, use Trimmomatic for paired-end data
        sample_name=$(basename "$forward_file" _1.fastq.gz)

        # Construct output file names
        output_paired1="$output_dir/${sample_name}_output_1_paired.fastq.gz"
        output_unpaired1="$output_dir/${sample_name}_output_1_unpaired.fastq.gz"
        output_paired2="$output_dir/${sample_name}_output_2_paired.fastq.gz"
        output_unpaired2="$output_dir/${sample_name}_output_2_unpaired.fastq.gz"

        # Run Trimmomatic for paired-end data
        "$trimmomatic_exec" PE "$phred_option" -threads "$threads" \
            "$forward_file" "$reverse_file" \
            "$output_paired1" "$output_unpaired1" \
            "$output_paired2" "$output_unpaired2" \
            LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    else
        # If reverse file is missing, use Trimmomatic for single-end data
        sample_name=$(basename "$forward_file" _1.fastq.gz)

        # Construct output file names
        output_unpaired1="$output_dir/${sample_name}_output_1_unpaired.fastq.gz"

        # Run Trimmomatic for single-end data
        "$trimmomatic_exec" SE "$phred_option" -threads "$threads" \
            "$forward_file" \
            "$output_unpaired1" \
            LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    fi
done

