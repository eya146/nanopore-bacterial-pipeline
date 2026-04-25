process PHANOTATE {
    tag "PHANOTATE"
    
    input:
    path assembly
    
    output:
    path "phanotate_output.gff", emit: gff
    path "phanotate_proteins.faa", emit: proteins
    
   script:
    """
    # Output GFF format
    phanotate.py ${assembly} -f gff > phanotate_output.gff
    
    # Output protein sequences in FASTA format
    phanotate.py ${assembly} -f faa > phanotate_proteins.faa
    """
}
