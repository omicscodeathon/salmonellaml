#!/bin/bash
# scriot to extract SRA ID's from biosample ID file
# Path to the biosample_accession.txt file
biosample_file="../accessions/kenya_trial.txt"
cat $biosample_file
epost -db biosample -input $biosample_file -format acc | elink -target sra | efetch -db sra -format runinfo -mode xml |
xtract -pattern Row -def "NA" -element Run spots bases spots_with_mates avgLength  size_MB download_path LibrarySelection LibrarySource  LibraryLayout InsertSize InsertDev Platform Mode | cut -f1> ../accessions/sra_accesions.txt
#Sample BioSample SampleType TaxID ScientificName SampleName CenterName  > metadata_sra.txt
