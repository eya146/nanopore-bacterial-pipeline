// ============================================
// Phage-Bacteria Metagenomic Pipeline
// Dataset: 38phages_SaSt (38 phages + Staphylococcus/Streptococcus)
// ============================================

// Import modules
include { NANOPLOT } from './modules/local/nanoplot.nf'
include { PORECHOP } from './modules/local/porechop.nf'
include { CHOPPER } from './modules/local/chopper.nf'
include { FLYE } from './modules/local/flye.nf'
include { MEDAKA } from './modules/local/medaka.nf'
include { QUAST } from './modules/local/quast.nf'
include { PHANOTATE } from './modules/local/phanotate.nf'
include { BLAST_ANNOTATION } from './modules/local/blast_annotation.nf'
include { MULTIQC } from './modules/local/multiqc.nf'

// Parameters
params.input = null
params.outdir = "/workspaces/nanopore-bacterial-pipeline/results"
params.genome_size = "3m"
params.min_read_length = 500
params.min_read_quality = 10

// Validate input
if (!params.input) {
    exit 1, "ERROR: Please provide input FASTQ file with --input"
}

// Create input channel
reads_ch = Channel.fromPath(params.input)

// Main workflow
workflow {
    log.info """
    ============================================================
    Phage-Bacteria Metagenomic Pipeline
    Dataset: 38phages_SaSt (38 phages + Staphylococcus/Streptococcus)
    ============================================================
    
    Input FASTQ      : ${params.input}
    Output directory : ${params.outdir}
    Genome size      : ${params.genome_size}
    
    Starting pipeline...
    """
    
    // Step 1: Raw QC
    log.info "[1/10] Running NanoPlot QC on raw reads..."
    NANOPLOT(reads_ch)
    
    // Step 2: Adapter trimming
    log.info "[2/10] Trimming adapters with Porechop..."
    PORECHOP(reads_ch)
    
    // Step 3: Read filtering
    log.info "[3/10] Filtering reads with Chopper..."
    CHOPPER(PORECHOP.out.trimmed, params.min_read_length, params.min_read_quality)
    
    // Step 4: Assembly
    FLYE(CHOPPER.out.filtered)

    // Step 5: Polishing (on all contigs)
    MEDAKA(FLYE.out.assembly, CHOPPER.out.filtered)

    // Step 6: Assembly QC
    QUAST(MEDAKA.out.polished)

    // Step 7: Gene prediction (on all contigs)
    PHANOTATE(MEDAKA.out.polished)

    // Step 8: Protein annotation (on all contigs)
    BLAST_ANNOTATION(PHANOTATE.out.proteins, MEDAKA.out.polished)
    
   // Step 9: MultiQC report
    log.info "[9/10] Generating MultiQC report..."

   def report_files = Channel.empty()
    .mix(NANOPLOT.out.html, QUAST.out.html)
    .collect()
    MULTIQC(report_files)
    
    log.info """
    ============================================================
    PIPELINE COMPLETE
    ============================================================
    
    Results saved to: ${params.outdir}
    
    - QC Report:        ${params.outdir}/NANOPLOT/
    - Trimmed reads:    ${params.outdir}/PORECHOP/
    - Filtered reads:   ${params.outdir}/CHOPPER/
    - Assembly:         ${params.outdir}/FLYE/
    - Polished:         ${params.outdir}/MEDAKA/
    - Assembly QC:      ${params.outdir}/QUAST/
    - Gene prediction:  ${params.outdir}/PHANOTATE/
    - Functional annotation: ${params.outdir}/BLAST/
    - Final report:     ${params.outdir}/MULTIQC/
    
    ============================================================
    """
}

workflow.onComplete {
    if (workflow.success) {
        log.info "Pipeline completed successfully!"
    } else {
        log.error "Pipeline failed. Check logs."
    }
}