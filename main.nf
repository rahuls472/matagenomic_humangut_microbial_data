nextflow.enable.dsl=2

include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp.nf'
include { KRAKEN } from './modules/kraken2.nf'


workflow {

    data_ch = Channel.fromFilePairs(params.data)

    database_ch = Channel.fromPath(params.database)

    // Quality check on raw reads
    FASTQC(data_ch)

    // Trim reads
    FASTP(data_ch)

    // Taxonomic classification
    KRAKEN(
       FASTP.out.trimmed_reads,
        database_ch
    )
}