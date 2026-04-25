process FLYE {
    tag "Flye"
    
    input:
    path reads
    
    output:
    path "assembly.fasta", emit: assembly
    path "assembly_info.txt", emit: info
    
    script:
    """
    flye --nano-raw ${reads} --meta --out-dir flye_output --threads ${task.cpus}
    cp flye_output/assembly.fasta .
    cp flye_output/assembly_info.txt .
    """
}
