#!/usr/bin/env nextflow
// Enable DSL2
nextflow.enable.dsl=2

// Define the parameter to hold the folder path
params.folder_path

// Import modules or define your processes here
include { EXTRACT_BIOSAMPLE_ID; 
          EXTRACT_SRA_IDS;
          DOWNLOAD;
          QUALITY_CONTROL
        } from './nextflow_modules'

// Use the parameter in your script
biosample_accessions = Channel.fromPath(params.folder_path, type: 'dir')

// Define the workflow structure
workflow {
    // Execute processes using the provided folder path
    //EXTRACT_BIOSAMPLE_ID(biosample_accessions)
    QUALITY_CONTROL(biosample_accessions)
}
