#!/bin/bash

# input="../swork/f0/eaf872d8c06c8f54a4dad2aa570fe3"

# for i in ${input}/*_1.fastq.gz;
# do
#     echo ${i}
#     name=$(basename ${i} _1.fastq.gz)
#     fastp -i ${i} -I ${input}/${name}_2.fastq.gz -o output/${name}_1_trimmed.fastq.gz -O output/${name}_2_trimmed.fastq.gz
# done

input="../work/f0/eaf872d8c06c8f54a4dad2aa570fe3"
output_dir="../data/trimmed_data"

mkdir ../data/trimmed_data  # Create output directory if it doesn't exist

for i in "$input"/*_1.fastq.gz; 
do
echo $processing $i
    name=$(basename "$i" _1.fastq.gz)
    fastp -i "$i" -I "$input/${name}_2.fastq.gz" -o "$output_dir/${name}_1_trimmed.fastq.gz" -O "$output_dir/${name}_2_trimmed.fastq.gz"
done
