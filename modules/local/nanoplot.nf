process NANOPLOT {
    tag "NanoPlot"
    conda "bioconda::nanoplot=1.41.0"
    
    input:
    path reads
    
    output:
    path "nanoplot_report.html", emit: html
    path "nanoplot_data/", emit: data
    
    script:
    """
    NanoPlot \\
        --fastq ${reads} \\
        --outdir nanoplot_data \\
        --verbose \\
        --N50 \\
        --title "Raw Reads QC Report"
    
    # For newer versions, HTML is default. Copy if exists
    if [ -f nanoplot_data/NanoPlot-report.html ]; then
        cp nanoplot_data/NanoPlot-report.html nanoplot_report.html
    elif [ -f nanoplot_data/NanoPlot.html ]; then
        cp nanoplot_data/NanoPlot.html nanoplot_report.html
    else
        echo "No HTML report generated" > nanoplot_report.html
    fi
    """
}