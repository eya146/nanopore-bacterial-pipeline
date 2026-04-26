process BLAST_ANNOTATION {
    tag "BlastAnnotation"
    
    input:
    path proteins
    path assembly
    
    output:
    path "blast_results.tsv", emit: results
    path "blast_summary.txt", emit: summary
    
    script:
    """
    # Use parameterized database paths
    blastp -query ${proteins} \
        -db /workspaces/nanopore-bacterial-pipeline/custom_db/staph_strep_db.faa \
        -dbtype prot \
        -out blast_results.tsv \
        -outfmt "6 qseqid sseqid pident length evalue stitle" \
        -max_target_seqs 1 \
        -evalue 1e-5 \
        -num_threads ${task.cpus}
    
    echo "=== BLAST Summary ===" > blast_summary.txt
    echo "Queries: \$(grep -c '>' ${proteins})" >> blast_summary.txt
    echo "Hits: \$(wc -l < blast_results.tsv)" >> blast_summary.txt
    """
}
