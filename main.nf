nextflow.enable.dsl=2

include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp.nf'
include { KRAKEN } from './modules/kraken2.nf'
include { KREPORT2KRONA } from './modules/kreport2krona.nf'
include { KRONA } from './modules/krona.nf'
include { REFASTQC } from './modules/refastqc.nf'


params.output = "results"


workflow {

    /*
     * Validate required parameters
     */

    if ( !params.input ) {
        error """
        Input FASTQ files are required.

        Example:

        nextflow run main.nf \
            --input 'data/*_{1,2}.fastq' \
            --database /path/to/kraken_database
        """
    }


    if ( !params.database ) {
        error """
        Kraken2 database path is required.

        Example:

        --database /path/to/kraken_database
        """
    }


    /*
     * Create paired-end FASTQ channel
     *
     * Expected input:
     *
     * sample_1.fastq
     * sample_2.fastq
     *
     * OR
     *
     * sample_R1.fastq
     * sample_R2.fastq
     */

    data_ch = Channel
        .fromFilePairs(
            params.input,
            checkIfExists: true
        )
        .map { sample_id, reads ->

            /*
             * Validate that exactly two files exist
             */

            if ( reads.size() != 2 ) {

                error """
                ERROR: Sample '${sample_id}' does not contain exactly two paired-end FASTQ files.

                Found:

                ${reads}

                Expected two files:

                sample_1.fastq
                sample_2.fastq

                or

                sample_R1.fastq
                sample_R2.fastq
                """
            }


            tuple(sample_id, reads)
        }


    /*
     * Kraken2 database
     */

    database_ch = Channel.fromPath(
        params.database,
        checkIfExists: true
    )


    /*
     * KrakenTools script
     */

    script_ch = Channel.fromPath(
        "${projectDir}/Script/KrakenTools/kreport2krona.py",
        checkIfExists: true
    )


    /*
     * STEP 1
     * Initial Quality Control
     */

    FASTQC(data_ch)


    /*
     * STEP 2
     * Read Trimming
     */

    FASTP(data_ch)


    /*
     * STEP 3
     * Quality Control After Trimming
     */

    REFASTQC(
        FASTP.out.trimmed_reads
    )


    /*
     * STEP 4
     * Taxonomic Classification
     */

    KRAKEN(
        FASTP.out.trimmed_reads,
        database_ch
    )


    /*
     * STEP 5
     * Convert Kraken Report for Krona
     */

    KREPORT2KRONA(
        KRAKEN.out.report,
        script_ch
    )


    /*
     * STEP 6
     * Generate Interactive Krona Visualization
     */

    KRONA(
        KREPORT2KRONA.out.krona_input
    )

}