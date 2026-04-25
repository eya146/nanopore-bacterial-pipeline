process MEDAKA {
    tag "Medaka"
    
    input:
    path assembly
    path reads
    
    output:
    path "polished.fasta", emit: polished
    
    script:
    """
    mkdir -p reads_dir
    cp ${reads} reads_dir/
    
    medaka_consensus -i reads_dir -d ${assembly} -o medaka_out -t ${task.cpus}
    cp medaka_out/consensus.fasta polished.fasta
    """
}