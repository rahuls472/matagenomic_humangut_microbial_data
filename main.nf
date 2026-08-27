nextflow.enable.dsl=2

include { FASTQC } from './modules/fastqc.nf'
include { FASTP } from './modules/fastp.nf'
include { KRAKEN } from './modules/kraken2.nf'
include {KREPORT2KRONA} from './modules/kreport2krona.nf'
include {KRONA} from './modules/krona.nf'


workflow {

    data_ch = Channel.fromFilePairs(params.data)

    database_ch = Channel.fromPath(params.database)

    script_ch = Channel.fromPath(
        "${projectDir}/Script/KrakenTools/kreport2krona.py"
    )

    FASTQC(data_ch)

    FASTP(data_ch)

    KRAKEN(
        FASTP.out.trimmed_reads,
        database_ch
    )

    KREPORT2KRONA(
        KRAKEN.out.report,
        script_ch
    )


    KRONA(
        KREPORT2KRONA.out.krona_input
    )
}