#!/bin/bash
# extract country from the run pipeline
# the file with country metadata
directory="../pipeline/run_salmonellaml"
#  extract the country name
country=$(find "$directory" -type f -name "*_biosamples.txt")
# Extract the country name from the file name, removing "sra" at the beginning
country_name=$(basename "$country" | sed 's/^sra_//;s/_.*//')
# Make the country directory
mkdir "../data/$country_name"

# reference sequnce for salmonella
REF="../data/salmonella_ref.fasta"
mkdir -p ../data/variants_out/01filter
variants_out="../data/variants_out"
echo "Indexing the reference genome"

mkdir -p ../data/output_dir/
output_dir="../data/output_dir" 

##*************************************************************************##
##  Step 1: Indexing the Reference                                         ## 
##*************************************************************************## 

# Uncomment the following line if indexing is not needed
bwa index "$REF"

##*************************************************************************##
##  Step 2: Mapping  to the Reference 
##*************************************************************************##
echo "mapping start at $(date)" 

# Loop through the paired-end read files
for forward in "$1"/*_1_trimmed.fastq.gz;
do
  reverse="${forward%_1_trimmed.fastq.gz}_2_trimmed.fastq.gz"
  base1=$(basename "$forward")
  out="${base1%_1_trimmed.fastq.gz}"
   # Check if the corresponding .snp file exists and is not empty
  if [ -f "../data/$out.snp" ] && [ -s "../data/$out.snp" ]; then
    echo "Skipping $out, corresponding .snp file exists and is not empty."
    continue
  fi


  # Perform read mapping using BWA-MEM and output to SAM file
  bwa mem -t 4 "$REF" "$forward" "$reverse" > "$output_dir/$out.sam"

  # Convert SAM to BAM
  samtools view -Sb "$output_dir/$out.sam" > "$output_dir/$out.bam"
  
  # Sort the BAM file using samtools
  echo "**samtools sort start at $(date)**"
  samtools sort "$output_dir/$out.bam" -o "$output_dir/$out.sorted.bam"
  
  # Remove the intermediate SAM and unsorted BAM files
  rm -f "$output_dir/$out.sam" "$output_dir/$out.bam"
  
  # Index the sorted BAM file
  samtools index "$output_dir/$out.sorted.bam"
  echo "**samtools sort finished at $(date)**"
  
  # Call variants using bcftools
  echo "**bcftools calling started at $(date)**"
  bcftools mpileup -f "$REF" "$output_dir/$out.sorted.bam" | bcftools call -vm -Oz > "$variants_out/$out.vcf.gz"
  echo "**bcftools calling finished at $(date)**"

  # SNP filtering
  vcftools --gzvcf "$variants_out/$out.vcf.gz" --minDP 4 --max-missing 0.2 --minQ 30 --recode --recode-INFO-all --out "$variants_out/01filter/$out.filter"
  vcftools --gzvcf "$variants_out/01filter/$out.filter.recode.vcf" --remove-indels --recode --recode-INFO-all --out "$variants_out/01filter/$out.filter.snps"
  vcftools --gzvcf "$variants_out/01filter/$out.filter.recode.vcf" --keep-only-indels --recode --recode-INFO-all --out "$variants_out/01filter/$out.filter.indels"
  
  # Extract GT (Genotype) information
  bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' "$variants_out/01filter/$out.filter.snps.recode.vcf" -o "$variants_out/01filter/$out.filter.snps.extract.txt"
  bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' "$variants_out/01filter/$out.filter.indels.recode.vcf" -o "$variants_out/01filter/$out.filter.indels.extract.txt"

  cut -d " " -f 2,3,4 "$variants_out/01filter/$out.filter.snps.extract.txt" > "../data/$country/$out.snp"
done

## SNP file list output to country snp file
ls ../data/"$country"/*.snp > ../data/"$country"_snp.lists
# remove the files in run-salmonella pipeline to process the next country
rm -r $directory
# remove the files in the work to process the next country
rm -r /work
# remove the outpu directory for stoting the intermediary files
rm -r output_dir
# remove trimmed data files
rm -r ../data/trimmed_data/*.gz