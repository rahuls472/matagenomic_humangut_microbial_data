include {FASTQC} from './modules/fastqc.nf'


workflow {
    data_ch = Channel.fromFilePairs(params.data)
    

    FASTQC(data_ch)

}