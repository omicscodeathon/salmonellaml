#!/usr/bin/env nextflow
// Define the Nextflow process for extracting Biosample IDs
process EXTRACT_BIOSAMPLE_ID {
    publishDir "${params.output}", mode:'copy' //define the directory where ouput should be saved
    // Input data files in the specified folder (passed as argument)
    input:
    path biosample_data_folder  //variable accessible only within this process

    // Output directory for saving Biosample IDs
    output:
    path "*.txt" // all outputs with .txt to be saved in the output folder

    script:
    """
    start_time=\$(date +'%Y-%m-%d %H:%M:%S')
    echo "Extracting biosample ids started at: \$start_time"
    python ${baseDir}/bin/extracting_biosample_ids_1.py ${biosample_data_folder}
    """
}
process EXTRACT_SRA_IDS {
    publishDir "${params.output}", mode:'copy' //define the directory where ouput should be saved
    // Input data files in the specified folder (passed as argument)
    input:
    path biosample_ids_file  //variable accessible only within this process

    // Output directory for saving Biosample IDs
    output:
    path "*.txt" // all outputs with .txt to be saved in the output folder

    script:
    """
    start_time=\$(date +'%Y-%m-%d %H:%M:%S')
    echo "Extracting sra ID's started at: \$start_time"
    bash ${baseDir}/bin/sra_from_biosample_2.sh ${biosample_ids_file}
    """
}

process DOWNLOAD {
    publishDir "${params.output}", mode:'copy' //define the directory where ouput should be saved
    // Input data files in the specified folder (passed as argument)
    input:
    path sra_file  //variable accessible only within this process

    // Output directory for saving Biosample IDs
    output:
    path "raw_data/*.gz" // all outputs with .gz to be saved in the output folder

    script:
    """
     start_time=\$(date +'%Y-%m-%d %H:%M:%S')
    echo "Download started at: \$start_time"
    bash ${baseDir}/bin/download_3.sh ${sra_file}
    stop_time=\$(date +'%Y-%m-%d %H:%M:%S')
    echo "downloding data at: \$start_time"
    """
}



 //cd work/b9/09ede2f2540db95563fd11e6487444/biosample_data/