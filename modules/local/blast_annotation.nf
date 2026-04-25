process BLAST_ANNOTATION {
    tag "BlastAnnotation"
    
    input:
    path proteins
    path assembly
    
    output:
    path "blast_viral.tsv", emit: viral_results
    path "blast_bacterial.tsv", emit: bacterial_results
    path "blast_summary.txt", emit: summary
    
    script:
    """
    # Viral database
    blastp -query ${proteins} \
        -db /workspaces/nanopore-bacterial-pipeline/custom_db/viral.1.protein.faa \
        -out blast_viral.tsv \
        -outfmt "6 qseqid sseqid pident length evalue stitle" \
        -max_target_seqs 1 \
        -evalue 1e-5 \
        -num_threads ${task.cpus}
    
    # Bacterial database (Staph + Strep)
    blastp -query ${proteins} \
        -db /workspaces/nanopore-bacterial-pipeline/custom_db/staph_strep_db.faa \
        -out blast_bacterial.tsv \
        -outfmt "6 qseqid sseqid pident length evalue stitle" \
        -max_target_seqs 1 \
        -evalue 1e-5 \
        -num_threads ${task.cpus}
    
    echo "=== BLAST Summary ===" > blast_summary.txt
    echo "Viral hits: \$(wc -l < blast_viral.tsv)" >> blast_summary.txt
    echo "Bacterial hits: \$(wc -l < blast_bacterial.tsv)" >> blast_summary.txt
    """
}