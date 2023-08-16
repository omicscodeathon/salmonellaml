#!/bin/bash

# Usage: bash script_name.sh input_file

# Make sure the input file is provided as the first argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 biosample_file"
  exit 1
fi

biosample_file="$1"

# Get the basename of the input file (without extension)
output_basename=$(basename "$biosample_file" | cut -d. -f1)

# Path to store the final SRA accessions file
output_file="./sra_${output_basename}.txt"

# Function to process a batch of BIOSAMPLE IDs and extract corresponding SRA IDs
process_batch() {
  local batch_input=$1
  local batch_output=$2

  # Fetch SRA IDs for the current batch of BIOSAMPLE IDs
  epost -db biosample -input "$batch_input" | elink -target sra | efetch -format docsum | xtract -pattern DocumentSummary -element Biosample,Run@acc >> "$batch_output"
}

# Initialize the temporary file to store BIOSAMPLE IDs
temp_file=$(mktemp)

# Process each BIOSAMPLE ID from the input file
for biosample_id in $(cat "$biosample_file"); do
  # Append the current BIOSAMPLE ID to the temporary file
  echo "$biosample_id" >> "$temp_file"
done

# Process all BIOSAMPLE IDs and extract SRA IDs
process_batch "$temp_file" "$output_file"

# Display the output in columns of two with tab as a separator
column -s $'\t' -t < "$output_file"

rm "$temp_file"
