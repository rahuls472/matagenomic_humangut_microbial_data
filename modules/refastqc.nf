
process REFASTQC {
    container 'biocontainers/fastqc:v0.11.9_cv8'
    publishDir "${params.output}/refastqc", mode: 'copy'


    input:
    tuple val(sample_id), path(reads1), path(reads2)


    output:
    path "*_fastqc.html"
    path "*_fastqc.zip"


    script:
    """
    fastqc ${reads1} ${reads2} 
    """
}