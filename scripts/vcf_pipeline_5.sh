# #!/bin/bash
# ##*************************************************************************##
# ##  Step 1: Indexing the Refeence ## 
# ##*************************************************************************##
# input_dir="../raw_data" 
# REF="../data/salmonella_ref.fasta"
# mkdir ../data/variants_out/01filter
# variants_out="../data/variants_out"
# echo "Indexing the reference genome"
# mkdir ../data/output_dir/
# output_dir="../data/output_dir" 
# #bwa index ../data/salmonella_ref.fasta

# ##*************************************************************************##
# ##  Step 2: Mapping  to the Refeence 
# ##*************************************************************************##do
#   echo "mapping start at $(date)" 
# for i in $(ls $input_dir) 
# do
# echo $i/$i".fastq.gz"
# bwa mem -t 4 $REF $input_dir/$i/$i".fastq.gz" | samtools view -bS -o $output_dir/$i.bam -

# # bwa mem -t 4 $REF $input_dir/$i/$i".fastq.gz" | $samtools view -Sb - > $output_dir/$i.bam
#  echo Mapping finished at $(date)
# ##*************************************************************************##
# ##                 Step2. sort the bam using samtools                      ##          
# ##*************************************************************************##

# echo "**samtools sort start at $(date)**"
# samtools sort $output_dir/$i.bam -O bam -o $output_dir/$i.sorted.bam
# # rm -f $output_dir/$i.bam
# samtools index $output_dir/$i.sorted.bam
# echo "**samtools sort finished at $(date)**"

# ##*************************************************************************##
# ##                 Step3. calling variants using bcftools                  ##          
# ##*************************************************************************##
# echo "**bcftools calling started at $(date)**"
# bcftools mpileup -f $REF $output_dir/$i.sorted.bam | bcftools call -vm -Oz > $variants_out/$i.vcf.gz
# echo "**bcftools calling finished at $(date)**"


# # ##*************************************************************************##
# # ##                        Step3. SNP_filter                                ##          
# # ##*************************************************************************##

# vcftools --gzvcf $variants_out/$i.vcf.gz --minDP 4 --max-missing 0.2 --minQ 30 --recode --recode-INFO-all --out $variants_out/01filter/$i.filter
# ### SNPs
# vcftools --gzvcf $variants_out/01filter/$i.filter.recode.vcf --remove-indels --recode --recode-INFO-all --out $variants_out/01filter/$i.filter.snps
# ### Indels
# vcftools --gzvcf $variants_out/01filter/$i.filter.recode.vcf --keep-only-indels --recode --recode-INFO-all --out $variants_out/01filter/$i.filter.indels

# ### extracting GT
# bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' $variants_out/01filter/$i.filter.snps.recode.vcf -o $variants_out/01filter/$i.filter.snps.extract.txt
# bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' $variants_out/01filter/$i.filter.indels.recode.vcf -o $variants_out/01filter/$i.filter.indels.extract.txt
#!/bin/bash

##*************************************************************************##
##  Step 1: Indexing the Reference                                         ## 
##*************************************************************************##
input_dir="../data/trimmed_data" 
REF="../data/salmonella_ref.fasta"
mkdir ../data/variants_out/01filter
variants_out="../data/variants_out"
echo "Indexing the reference genome"
mkdir ../data/output_dir/
output_dir="../data/output_dir" 
#bwa index ../data/salmonella_ref.fasta

##*************************************************************************##
##  Step 2: Mapping  to the Refeence 
##*************************************************************************##
echo "mapping start at $(date)" 
# Loop through the paired-end read files
for i in  $(ls $input_dir/*_1_paired.fastq.gz);
do
  echo $i kk

  foward=$i
  out=$(basename "$i")
  echo "Processing $foward" # Changed $base to $foward

  # Get the corresponding _2_paired.fastq file
#   reverse="$i/${foward}_2_paired.fastq.gz" # Changed $base to $foward
  # Get the corresponding _2_paired.fastq file
  reverse="${i%_1_paired.fastq.gz}_2_paired.fastq.gz" # Replace "_1_paired" with "_2_paired"
  

  # Perform read mapping using BWA-MEM
  bwa mem -t 4 $REF "$foward" "$reverse" | $samtools view -Sb > "$output_dir/$out.bam"
done
# bwa mem -t 4 $REF $input_dir/$i/$i".fastq.gz" | $samtools view -Sb - > $output_dir/$i.bam
echo Mapping finished at $(date)

##*************************************************************************##
## Step3. sort the bam using samtools                      ##          
##*************************************************************************##

echo "**samtools sort start at $(date)**"
samtools sort $output_dir/$out.bam -O bam -o $output_dir/$out.sorted.bam
# rm -f $output_dir/$i.bam
samtools index $output_dir/$out.sorted.bam
echo "**samtools sort finished at $(date)**"

##*************************************************************************##
##                 Step3. calling variants using bcftools                  ##          
##*************************************************************************##
echo "**bcftools calling started at $(date)**"
bcftools mpileup -f $REF $output_dir/$out.sorted.bam | bcftools call -vm -Oz > $variants_out/$out.vcf.gz
echo "**bcftools calling finished at $(date)**"

# ##*************************************************************************##
# ##                        Step3. SNP_filter                                ##          
# ##*************************************************************************##

vcftools --gzvcf $variants_out/$out.vcf.gz --minDP 4 --max-missing 0.2 --minQ 30 --recode --recode-INFO-all --out $variants_out/01filter/$out.filter
### SNPs
vcftools --gzvcf $variants_out/01filter/$out.filter.recode.vcf --remove-indels --recode --recode-INFO-all --out $variants_out/01filter/$out.filter.snps
### Indels
vcftools --gzvcf $variants_out/01filter/$out.filter.recode.vcf --keep-only-indels --recode --recode-INFO-all --out $variants_out/01filter/$out.filter.indels

### extracting GT
bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' $variants_out/01filter/$out.filter.snps.recode.vcf -o $variants_out/01filter/$out.filter.snps.extract.txt
bcftools query -f '%CHROM %POS %REF %ALT [%TGT]\n' $variants_out/01filter/$out.filter.indels.recode.vcf -o $variants_out/01filter/$out.filter.indels.extract.txt

cut -d " " -f 2,3,4 $variants_out/01filter/$out.filter.snps.extract.tx >../data/$out.snp;
 
done

## SNP file list
ls ../data/*.snp > ../data/snp.lists
