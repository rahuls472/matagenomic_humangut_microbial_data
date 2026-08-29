process KRONA {
    container 'staphb/krona:latest'
    publishDir "${params.output}/krona_results", mode: 'copy'

    input:
    path krona_input

    output:
    path "krona.html"

    script:
    """
    ktImportText ${krona_input} -o krona.html
    """
}