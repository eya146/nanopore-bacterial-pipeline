# Nanopore Phage-Bacteria Assembly Pipeline

[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A522.10.0-brightgreen.svg)](https://www.nextflow.io/)
[![Conda](https://img.shields.io/badge/conda-environment-green.svg)](https://conda.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Nextflow pipeline for assembly and characterization of phage genomes from mixed Nanopore sequencing data.

## System Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| **CPUs** | 4 cores | 8+ cores |
| **RAM** | 16 GB | 32+ GB |
| **Disk space** | 20 GB | 50 GB |

### GitHub Codespace Requirements

For successful assembly with Flye, use a **4-core Codespace** with at least **16 GB RAM**:|

#### Alternative for 2-core / Low Memory:

If using a 2-core Codespace or limited resources, use **Raven** instead of Flye

## Results Summary

| Category | Metric | Value |
|----------|--------|-------|
| **Complete Phage Genome** | Length | 61.8  kb |
| | Coverage | 699x |
| | Circular | Yes |
| | Contig | contig_5 |
| **Assembly Statistics** | Number of contigs | 5 |
| | Largest contig | 61,841 bp |
| | Total length | 	190,372 bp bp |
| | N50 | 41,164 bp bp |
| | L50 | 2 |
| | N's per 100 kbp | 0 |
| **Gene Prediction** | Total predicted proteins | 542 |
| **Viral Annotation** | Total viral hits | 233 |
| | Vibrio phages | 70 |
| | Pseudomonas phages | 93 |
| | Other genera | 60 |
| **Bacterial Annotation** | Total bacterial hits | 14 |
| | Staphylococcus aureus | 11 |
| | Streptococcus pneumoniae | 3 |
| **Key Proteins Identified** | DNA polymerase I | Replication |
| | DNA methyltransferase | Modification |
| | Terminase (large/small) | DNA packaging |
| | Portal protein | Head assembly |
| | Major capsid protein | Head structure |
| | Major tail protein | Tail structure |
| | Endolysin | Host lysis |
| | Integrase | Integration |
| **Read Quality** | Total reads | 5,251 |
| | Total reads (filtered, ≥500bp, Q≥10) | 5,250 |
| | Total bases | 50.8 Mb |
| | Mean read length | 9.7 kb |
| | Read N50 | 14.4 kb |
| | Mean quality (Q-score) | 13.6 |
| | Max read length | 255 kb |

## Phage Species Identified

BLAST annotation revealed matches to phages infecting the following genera:

| Genus | Number of hits | Example Phage |
|-------|----------------|---------------|
| **Pseudomonas** | 93 | Pseudomonas phage PA11, Pseudomonas phage Henninger |
| **Vibrio** | 70 | Vibrio phage douglas 12A4, Vibrio phage ICP1|
| **Salmonella** | 13 | Salmonella phage vB_SenS_Sasha |
| **Klebsiella** | 9 | Klebsiella phage vB_KpnS-Carvaje |
| **Pseudoalteromonas** | 6 | Pseudoalteromonas phage Maelstrom |
| **Edwardsiella** | 2 | Edwardsiella phage MSW-3 |
| **Xanthomonas** | 3 | Xanthomonas phage Xp15 |
| **Enterococcus** | 1 | Enterococcus phage phiFL4A |
| **Bacillus** | 1 | Bacillus phage IEBH |
| **Proteus** | 4 | Proteus phage VB_PmiS-Isfahan |
| **Aeromonas** | 2 | Aeromonas phage 2L372X |
| **Erwinia** | 3 | Erwinia phage Hena1 |

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

# Initialize conda (first time only)
conda init bash
source ~/.bashrc

# Create conda environment
conda env create -f environment.yml

# Activate environment
conda activate nanopore-pipeline

# If activation fails, use:
# source /opt/conda/etc/profile.d/conda.sh && conda activate nanopore-pipeline

# Run pipeline
nextflow run main.nf --input your_reads.fastq -profile conda

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
Output Structure
text
results/
├── NANOPLOT/      # Read QC report
├── PORECHOP/      # Trimmed reads
├── CHOPPER/       # Filtered reads
├── FLYE/          # Assembly (5 contigs)
├── MEDAKA/        # Polished assembly
├── QUAST/         # Assembly QC report
├── PHANOTATE/     # Gene predictions (563 proteins)
├── BLAST/         # Protein annotations (233 viral hits, 14 bacterial hits)
└── MULTIQC/       # Aggregated report
Assembly Results
Initial Assembly (Flye)
Contig	Length	Coverage	Circular
contig_5	61.8 kb	699x	Yes
contig_3	39.3 kb	4x	No
contig_4	41.1 kb	5x	No
contig_1	36.7 kb	4x	No
contig_2	37.5 kb	2x	Yes
Polished Assembly (Medaka)
After assembly and polishing, contig_1 was identified as the complete circular phage genome (61.8 kb, 699x coverage, 0 gaps). Additional contigs (contig_2-5) represent bacterial host fragments or low-coverage sequences.

Metric	Value
Number of contigs	5
Largest contig	61,841 bp
Total length	190,372 bp
N50	41,164 bp
L50	2
N's per 100 kbp	0
Read Quality Statistics (NanoPlot)
Metric	Value
Total reads	5,250
Total bases	50.8 Mb
Mean read length	9.7 kb
Read length N50	13.6 kb
Mean quality (Q-score)	14.1
Max read length	255 kb

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
