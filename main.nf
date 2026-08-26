include {FASTQC} from './modules/fastqc.nf'
include {FASTP} from './modules/fastp.nf'


workflow {
    data_ch = Channel.fromFilePairs(params.data)
    

    FASTQC(data_ch)

    fastp_ch = FASTP(data_ch)



}