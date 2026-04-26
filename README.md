# Nanopore Phage-Bacteria Assembly Pipeline

[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A522.10.0-brightgreen.svg)](https://www.nextflow.io/)
[![Conda](https://img.shields.io/badge/conda-environment-green.svg)](https://conda.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Nextflow pipeline for assembly and characterization of phage genomes from mixed Nanopore sequencing data.

## Results Summary

| Metric | Value |
|--------|-------|
| Complete phage genome | 58.8 kb, circular, 714x coverage |
| Total contigs assembled | 5 |
| Predicted proteins | 563 |
| Viral BLAST hits | 233 |
| Assembly quality | N50 = total length, 0 N's |
| Read N50 | 14.4 kb |

## Phage Species Identified

BLAST annotation revealed matches to phages infecting the following genera:

| Genus | Number of hits | Example Phage |
|-------|----------------|---------------|
| **Vibrio** | 45+ | Vibrio phage douglas 12A4, Vibrio phage ICP1 |
| **Klebsiella** | 25+ | Klebsiella phage vB_KpnS-Carvaje |
| **Salmonella** | 20+ | Salmonella phage vB_SenS_Sasha |
| **Pseudomonas** | 18+ | Pseudomonas phage PA11, Pseudomonas phage Henninger |
| **Pseudoalteromonas** | 8+ | Pseudoalteromonas phage Maelstrom |
| **Edwardsiella** | 5+ | Edwardsiella phage MSW-3 |
| **Xanthomonas** | 5+ | Xanthomonas phage Xp15 |
| **Enterococcus** | 3+ | Enterococcus phage phiFL4A |
| **Bacillus** | 2+ | Bacillus phage IEBH |
| **Proteus** | 3+ | Proteus phage VB_PmiS-Isfahan |
| **Aeromonas** | 2+ | Aeromonas phage 2L372X |
| **Erwinia** | 2+ | Erwinia phage Hena1 |

**Key phage proteins identified:**
- DNA polymerase I (replication)
- DNA methyltransferase (modification)
- Terminase large subunit (DNA packaging)
- Portal protein (head assembly)
- Major capsid protein (head structure)
- Major tail protein (tail structure)
- Endolysin (host lysis)

## Pipeline Overview
FASTQ → NanoPlot → Porechop → Chopper → Flye → Medaka → QUAST → PHANOTATE → BLAST → MultiQC

text

| Step | Tool | Purpose |
|------|------|---------|
| 1 | NanoPlot | Raw read QC |
| 2 | Porechop | Adapter trimming |
| 3 | Chopper | Read filtering (min 500bp, Q10) |
| 4 | Flye | Metagenomic assembly with --meta mode |
| 5 | Medaka | Polishing (R10.4.1 model) |
| 6 | QUAST | Assembly QC |
| 7 | PHANOTATE | Phage gene prediction |
| 8 | BLAST | Protein annotation (viral + bacterial) |
| 9 | MultiQC | Aggregate report |

## Installation

### Prerequisites

- Nextflow (>=22.10.0)
- Conda or Mamba
- 8 GB RAM (16 GB recommended)

### Setup

```bash
# Clone repository
git clone https://github.com/eya146/nanopore-bacterial-pipeline.git
cd nanopore-bacterial-pipeline

# Create conda environment
conda env create -f environment.yml
conda activate nanopore-pipeline

# Run pipeline
nextflow run main.nf --input your_reads.fastq -profile conda
Usage
Basic Run
bash
nextflow run main.nf --input reads.fastq -profile conda
With Custom Parameters
bash
nextflow run main.nf \
    --input reads.fastq \
    --outdir ./results \
    --genome_size 3m \
    -profile conda
Resume Interrupted Run
bash
nextflow run main.nf --input reads.fastq -resume
Help
bash
nextflow run main.nf --help
Output Structure
text
results/
├── NANOPLOT/      # Read QC report
├── PORECHOP/      # Trimmed reads
├── CHOPPER/       # Filtered reads
├── FLYE/          # Assembly (5 contigs)
├── MEDAKA/        # Polished assembly (1 contig)
├── QUAST/         # Assembly QC report
├── PHANOTATE/     # Gene predictions (563 proteins)
├── BLAST/         # Protein annotations (233 viral hits)
└── MULTIQC/       # Aggregated report
Assembly Results
Initial Assembly (Flye)
Contig	Length	Coverage	Circular
contig_1	58.8 kb	714x	Yes
contig_2	41.5 kb	4x	No
contig_3	41.1 kb	5x	No
contig_4	39.3 kb	4x	No
contig_8	37.5 kb	2x	Yes
Polished Assembly (Medaka)
After polishing, only the high-coverage contig (contig_1) was successfully processed, resulting in a single complete circular phage genome.

Metric	Value
Number of contigs	1
Largest contig	58,830 bp
Total length	58,830 bp
N50	58,830 bp
L50	1
N's per 100 kbp	0
Read Quality Statistics (NanoPlot)
Metric	Value
Total reads	5,251
Total bases	50.8 Mb
Mean read length	9.7 kb
Read length N50	14.4 kb
Mean quality (Q-score)	13.1
Max read length	255 kb
Requirements
RAM: 8 GB minimum (16 GB recommended)

CPUs: 2-4 cores

Disk: 20 GB free space

Limitations
Flye assembly requires significant memory (8-16 GB). For low-memory environments, use Raven instead.

Medaka polishing only succeeds for high-coverage contigs (>50x).


License
MIT

Author
Evangelia Sklaveniti

Acknowledgments
Prof. Bas E. Dutilh, Viral Ecology and Omics Group, FSU Jena

Cluster of Excellence Balance of the Microverse

Repository
https://github.com/eya146/nanopore-bacterial-pipeline
