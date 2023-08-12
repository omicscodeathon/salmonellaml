
# for i in *.fastq.gz;
# do
#     name=$(basename ${i}.fastq.gz)
#     fastp -i ${i} -I ${name}_2.fastq.gz -o ./${name}_1_trimmed.fastq.gz -O ./${name}_2_trimmed.fastq.gz

# done
#!/bin/bash

# input="../swork/f0/eaf872d8c06c8f54a4dad2aa570fe3"

# for i in ${input}/*_1.fastq.gz;
# do
#     echo ${i}
#     name=$(basename ${i} _1.fastq.gz)
#     fastp -i ${i} -I ${input}/${name}_2.fastq.gz -o output/${name}_1_trimmed.fastq.gz -O output/${name}_2_trimmed.fastq.gz
# done

input=$1
# mkdir ../data/trimmed_data  # Create output directory if it doesn't exist
# output_dir="../data/trimmed_data"

for i in "$input"/*_1.fastq.gz; 
do
echo $processing $i
    name=$(basename "$i" _1.fastq.gz)
    fastp -i "$i" -I "$input/${name}_2.fastq.gz" -o "./${name}_1_trimmed.fastq.gz" -O "./${name}_2_trimmed.fastq.gz"
done
