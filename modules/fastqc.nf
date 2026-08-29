
process FASTQC {
    container 'biocontainers/fastqc:v0.11.9_cv8'
    publishDir "${params.output}/fastqc", mode: 'copy'


    input:
    tuple val(sample_id), path(reads)


    output:
    path "*_fastqc.html"
    path "*_fastqc.zip"


    script:
    """
    fastqc ${reads[0]} ${reads[1]} 
    """
}