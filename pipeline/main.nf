// Enable DSL2
nextflow.enable.dsl=2
// Define the parameter to hold the folder path
params.folder_path = file("${baseDir}/accessions/")  // Default value if not provided

// Set a default value for biosample_data parameter
include { EXTRACT_BIOSAMPLE_ID;
      EXTRACT_SRA_IDS;
      DOWNLOAD
      
      } from './modules/nextflow_modules'

log.info """\
Salmonelle enterica source attribution Pipeline v$params.version
 ========================================================
 //params defined in nextconfig file
Input file    : ${params.folder_path ? params.folder_path : params.folder_path}
Output directory  : ${params.output}
"""

biosample_accessions = Channel.fromPath("${params.folder_path}", type: 'dir')

// execute the process

workflow {
    EXTRACT_BIOSAMPLE_ID(biosample_accessions)
    
    EXTRACT_SRA_IDS(EXTRACT_BIOSAMPLE_ID.out.view()) //pass last process's output to this process
   DOWNLOAD(EXTRACT_SRA_IDS.out.view()) //pass last process's output to this process
   //QUALITY_CONTROL(DOWNLOAD.out.view())

}
