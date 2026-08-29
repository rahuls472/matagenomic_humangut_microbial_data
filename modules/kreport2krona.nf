process KREPORT2KRONA {

    container 'python:3.10'

    publishDir "${params.output}/krona", mode: 'copy'

    input:
    path report
    path script

    output:
    path "output.krona", emit: krona_input

    script:
    """
    python ${script} \
        -r ${report} \
        -o output.krona
    """
}