process PORECHOP {
    tag "Porechop"
    conda "bioconda::porechop=0.2.4"
    
    input:
    path reads
    
    output:
    path "trimmed.fastq", emit: trimmed
    
    script:
    """
    porechop \
        -i ${reads} \
        -o trimmed.fastq \
        --threads ${task.cpus} \
        --verbosity 1
    """
}