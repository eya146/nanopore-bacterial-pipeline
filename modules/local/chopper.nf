process CHOPPER {
    tag "Chopper"
    
    input:
    path reads
    val min_length
    val min_quality
    
    output:
    path "filtered.fastq", emit: filtered
    path "chopper_stats.txt", emit: stats
    
    script:
    """
    # Count original reads
      original_reads=$(($(wc -l < ${reads}) / 4))
      filtered_reads=$(($(wc -l < filtered.fastq) / 4))
    
    # Filter reads
    chopper \\
        -l ${min_length} \\
        -q ${min_quality} \\
        < ${reads} \\
        > filtered.fastq
    
    # Count filtered reads
    filtered_reads=\$(grep -c "^@" filtered.fastq)
    filtered_bases=\$(awk 'NR%4==2 {sum+=length(\$0)} END {print sum}' filtered.fastq)
    
    # Save statistics
    cat > chopper_stats.txt << _STATS_
    Filtering Statistics
    ===================
    Min length: ${min_length}
    Min quality: ${min_quality}
    
    Original reads: \${original_reads}
    Filtered reads: \${filtered_reads}
    Reads removed: \$((original_reads - filtered_reads))
    
    Original bases: \${original_bases}
    Filtered bases: \${filtered_bases}
    _STATS_
    """
}