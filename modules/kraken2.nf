process KRAKEN {

    container 'staphb/kraken2:latest'

    publishDir "${params.output}/kraken2", mode: 'copy'

    input:
    tuple val(sample_id), path(read1), path(read2)
    path database

    output:
    path "${sample_id}_kraken2_report.txt", emit: report
    path "${sample_id}_kraken2_output.txt", emit: output

    script:
    """
    kraken2 \
        --db ${database} \
        --memory-mapping \
        --paired ${read1} ${read2} \
        --report ${sample_id}_kraken2_report.txt \
        --output ${sample_id}_kraken2_output.txt
    """
}