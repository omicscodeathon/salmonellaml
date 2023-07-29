#!/bin/bash
# scriot to extract SRA ID's from biosample ID file
# Path to the biosample_accession.txt file
# biosample_file="../accessions/kenya_biosamples.txt"
# cat $biosample_file
# epost -db biosample -input $biosample_file -format acc | elink -target sra | efetch -db sra -format runinfo -mode xml |
# xtract -pattern Row -def "NA" -element Run spots bases spots_with_mates avgLength  size_MB download_path LibrarySelection LibrarySource  LibraryLayout InsertSize InsertDev Platform Mode | cut -f1> ../accessions/sra_accesions.txt
# #Sample BioSample SampleType TaxID ScientificName SampleName CenterName  > metadata_sra.txt
#!/bin/bash

# Script to extract SRA IDs from biosample ID file

# Path to the biosample_accession.txt file
biosample_file="../accessions/kenya_biosamples.txt"

# Path to store the final SRA accessions file
output_file="../accessions/sra_accesions.txt"

# Function to process a batch of BIOSAMPLE IDs and extract corresponding SRA IDs
process_batch() {
  local batch_input=$1
  local batch_output=$2

  # Fetch SRA IDs for the current batch of BIOSAMPLE IDs
  epost -db biosample -input "$batch_input" -format acc | elink -target sra | efetch -db sra -format runinfo -mode xml |
    xtract -pattern Row -def "NA" -element Run spots bases spots_with_mates avgLength size_MB download_path LibrarySelection LibrarySource LibraryLayout InsertSize InsertDev Platform Mode | cut -f1 >> "$batch_output"
}

# Initialize a counter to track the number of processed BIOSAMPLE IDs
counter=0

# Initialize a temporary file to store batches of BIOSAMPLE IDs
temp_file=$(mktemp)

# Read the BIOSAMPLE IDs file line by line
while read -r biosample_id; do
  # Append the current BIOSAMPLE ID to the temporary file
  echo "$biosample_id" >> "$temp_file"

  # Increment the counter
  ((counter++))

  # Check if 20 BIOSAMPLE IDs have been processed
  if [ "$counter" -eq 50 ]; then
    # Process the batch and extract SRA IDs
    process_batch "$temp_file" "$output_file"

    # Reset the counter and clear the temporary file
    counter=0
    rm "$temp_file"
    temp_file=$(mktemp)
  fi
done < "$biosample_file"

# Process any remaining BIOSAMPLE IDs (less than 20)
if [ "$counter" -gt 0 ]; then
  process_batch "$temp_file" "$output_file"
  rm "$temp_file"
fi
