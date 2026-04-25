process MULTIQC {
    tag "MultiQC"
    
    input:
    path reports
    
    output:
    path "multiqc_report.html", emit: html
    
    script:
    """
    # Run MultiQC in the results directory where all reports are
    multiqc ${params.outdir} --title "Nanopore Bacterial Pipeline Report" --filename multiqc_report.html
    """
}