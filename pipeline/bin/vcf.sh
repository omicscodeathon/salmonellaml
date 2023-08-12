#!/bin/bash
##*************************************************************************##
##  Step 0: Download Reference Genome using Accession Number               ##
##*************************************************************************##
accession="NZ_JAPQLD010000001.1"
reference_url="https://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?id=$accession&db=nuccore&report=fasta&retmode=text&withmarkup=on"

echo "Downloading the reference genome with accession $accession"
wget -O reference.fasta "$reference_url"
##*************************************************************************##
##  Step 1: Indexing the Reference                                         ## 
##*************************************************************************##
input_dir="./" 
REF=$input_dir/*ref.fasta
# mkdir ../data/variants_out/01filter
variants_out="./"
echo "Indexing the reference genome"
# mkdir ../data/output_dir/
output_dir="./" 
#bwa index ../data/salmonella_ref.fasta

##*************************************************************************##
##  Step 2: Mapping  to the Refeence 
##*************************************************************************##
echo "mapping start at $(date)" 

# Loop through the paired-end read files
for i in  $(ls $input_dir/*_1_trimmed.fastq.gz);
do
  foward=$i
  reverse="${i%_1_trimmed.fastq.gz}_2_trimmed.fastq.gz"
  base1=$(basename "$i")
  out="${base1%_1_paired.fastq.gz}"

  # Perform read mapping using BWA-MEM and output to SAM file
  bwa mem -t 4 $REF "$foward" "$reverse" > "$output_dir/$out.sam"

  # Convert SAM to BAM
  samtools view -Sb "$output_dir/$out.sam" > "$output_dir/$out.bam"
  
  # Sort the BAM file using samtools
  echo "**samtools sort start at $(date)**"
  samtools sort "$output_dir/$out.bam" -O bam -o "$output_dir/$out.sorted.bam"
  
  # Remove the intermediate SAM and unsorted BAM files
  rm -f "$output_dir/$out.sam" "$output_dir/$out.bam"
  
  # Index the sorted BAM file
  samtools index "$output_dir/$out.sorted.bam"
  echo "**samtools sort finished at $(date)**"
  
  # Call variants using bcftools
  echo "**bcftools calling started at $(date)**"
  bcftools mpileup -f $REF "$output_dir/$out.sorted.bam" | bcftools call -vm -Oz > "$variants_out/$out.vcf.gz"
  echo "**bcftools calling finished at $(date)**"

  # SNP filtering
  vcftools --gzvcf "$variants_out/$out.vcf.gz" --minDP 4 --max-missing 0.2 --minQ 30 --recode --recode-INFO-all --out "$variants_out/01filter/$out.filter"
  vcftools --gzvcf "$variants_out/01filter/$out.filter.recode.vcf" --remove-indels --recode --recode-INFO-all --out "$variants_out/01filter/$out.filter.snps"
  vcftools --gzvcf "$variants_out/01filter/$out.filter.recode.vcf" --keep-only-indels --recode --recode-INFO-all --out "$variants_out/01filter/$out.filter.indels"
  
  # Extract GT (Genotype) information
  bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' "$variants_out/01filter/$out.filter.snps.recode.vcf" -o "$variants_out/01filter/$out.filter.snps.extract.txt"
  bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' "$variants_out/01filter/$out.filter.indels.recode.vcf" -o "$variants_out/01filter/$out.filter.indels.extract.txt"

  cut -d " " -f 2,3,4 "$variants_out/01filter/$out.filter.snps.extract.txt" > "../data/$out.snp"
 
done

## SNP file list output
ls ../data/*.snp > ../data/snp.lists
rm -r 
