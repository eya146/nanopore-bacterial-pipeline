process QUAST {
    tag "QUAST"
    conda "bioconda::quast=5.2.0"
    
    input:
    path assembly
    
    output:
    path "quast_report.html", emit: html
    path "quast_report.txt", emit: report
    
    script:
    """
    quast.py ${assembly} -o quast_output --fast
    
    # Check if HTML was generated
    if [ -f quast_output/report.html ]; then
        cp quast_output/report.html quast_report.html
    else
        # Create a simple HTML from the text report
        echo "<html><body><pre>" > quast_report.html
        cat quast_output/report.txt >> quast_report.html
        echo "</pre></body></html>" >> quast_report.html
    fi
    
    cp quast_output/report.txt quast_report.txt
    """
}