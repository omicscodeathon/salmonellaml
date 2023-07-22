#!/bin/bash
##*************************************************************************##
##  Step 1: Indexing the Refeence ## 
##*************************************************************************##
input_dir="../raw_data" 
REF="../data/salmonella_ref.fasta"
echo "Indexing the reference genome"
mkdir ../data/output_dir
output_dir="../data/output_dir" 
#bwa index ../data/salmonella_ref.fasta

##*************************************************************************##
##  Step 2: Mapping  to the Refeence 
##*************************************************************************##do
  echo "mapping start at $(date)" 
for i in $(ls $input_dir) 
do
echo $i/$i".fastq.gz"
bwa mem -t 4 $REF $input_dir/$i/$i".fastq.gz" | $samtools view -Sb - > $output_dir/$i.bam

done
  echo Mapping finished at $(date)
