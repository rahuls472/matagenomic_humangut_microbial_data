process FASTP {

    container 'biocontainers/fastp:v0.19.6dfsg-1-deb_cv1'

    publishDir "${params.output}/fastp", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id),
          path("trimmed_${sample_id}_R1.fastq"),
          path("trimmed_${sample_id}_R2.fastq"),
          emit: trimmed_reads

    script:
    """
    fastp \
        -i ${reads[0]} \
        -I ${reads[1]} \
        -o trimmed_${sample_id}_R1.fastq \
        -O trimmed_${sample_id}_R2.fastq
    """
}