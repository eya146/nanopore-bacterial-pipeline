# Nanopore Phage-Bacteria Assembly Pipeline

[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A522.10.0-brightgreen.svg)](https://www.nextflow.io/)
[![Conda](https://img.shields.io/badge/conda-environment-green.svg)](https://conda.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Nextflow pipeline for assembly and characterization of phage genomes from mixed Nanopore sequencing data. **Successfully identified a complete circular phage genome (61.8 kb) from a 38-phage cocktail experiment against *Staphylococcus aureus* and *Streptococcus*.**

---

## System Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| **CPUs** | 4 cores | 8+ cores |
| **RAM** | 16 GB | 32+ GB |
| **Disk space** | 20 GB | 50 GB |

### GitHub Codespace Requirements

For successful assembly with Flye, use a **4-core Codespace** with at least **16 GB RAM**.

#### Alternative for 2-core / Low Memory

If using a 2-core Codespace or limited resources, use **Raven** instead of Flye.

---

## Results Summary

### Complete Phage Genome

| Metric | Value |
|--------|-------|
| **Length** | 61.8 kb |
| **Coverage** | 699x |
| **Circular** | Yes |
| **Contig** | contig_5 |
| **Identity** | Pseudomonas-like (Bf7 family) |

### Assembly Statistics

| Metric | Value |
|--------|-------|
| Number of contigs | 5 |
| Largest contig | 61,841 bp |
| Total length | 190,372 bp |
| N50 | 41,164 bp |
| L50 | 2 |
| N's per 100 kbp | 0 |

### Gene Prediction

| Metric | Value |
|--------|-------|
| Total predicted proteins | 542 |

### Viral Annotation (233 total hits)

| Genus | Hits | Example Phage |
|-------|------|----------------|
| **Pseudomonas** | 93 | Pseudomonas phage PA11, Henninger, Bf7 |
| **Vibrio** | 70 | Vibrio phage douglas 12A4, ICP1 |
| **Salmonella** | 13 | Salmonella phage vB_SenS_Sasha |
| **Klebsiella** | 9 | Klebsiella phage vB_KpnS-Carvaje |
| **Pseudoalteromonas** | 6 | Pseudoalteromonas phage Maelstrom |
| **Proteus** | 4 | Proteus phage VB_PmiS-Isfahan |
| **Xanthomonas** | 3 | Xanthomonas phage Xp15 |
| **Erwinia** | 3 | Erwinia phage Hena1 |
| **Other genera** | 32 | Edwardsiella, Aeromonas, Enterococcus, Bacillus |

### Bacterial Annotation (14 hits)

| Host | Hits |
|------|------|
| **Staphylococcus aureus** | 11 |
| **Streptococcus pneumoniae** | 3 |

### Key Proteins Identified

| Protein | Function |
|---------|----------|
| DNA polymerase I | Replication |
| DNA methyltransferase | Modification |
| Terminase (large/small) | DNA packaging |
| Portal protein | Head assembly |
| Major capsid protein | Head structure |
| Major tail protein | Tail structure |
| Endolysin | Host lysis |
| Integrase | Integration |

### Read Quality Statistics (NanoPlot)

| Metric | Value |
|--------|-------|
| Total reads (raw) | 5,251 |
| Total reads (filtered, >=500bp, Q>=10) | 5,250 |
| Total bases | 50.8 Mb |
| Mean read length | 9.7 kb |
| Read N50 | 14.4 kb |
| Mean quality (Q-score) | 13.6 |
| Max read length | 255 kb |

---

## Biological Interpretation

### What I Found

| Component | Description |
|-----------|-------------|
| **Active phage (contig_5)** | Complete, circular Pseudomonas-like phage (Bf7 family) at **699x coverage** - actively replicating |
| **Prophage remnant (contig_3)** | Pseudomonas 17A/Henninger-like prophage integrated in *S. aureus* DNA - evidence of **past infection** |
| **Ancient prophage debris (contig_1,2,4)** | Diverse, low-identity hits (Vibrio, Klebsiella, Salmonella) - **fossil record** of historical infections |
| **Bacterial hosts** | *S. aureus* and *S. pneumoniae* - confirmed by bacterial BLAST |

### Key Insight

The sample (`SaSt` = *S. aureus* + *Streptococcus*) was designed to test **38 phages** against these hosts. Our assembly captured:

1. A **successful active infection** (Pseudomonas Bf7-like phage, high coverage)
2. **Historical prophage integrations** (different Pseudomonas strain in host chromosome)
3. **Ancient phage debris** from diverse genera (Vibrio, Klebsiella, Salmonella)

**This demonstrates that the pipeline successfully identifies both actively replicating phages and the prophage history of the host genome.**

---

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

---

## Installation

### Prerequisites

- Nextflow (>=22.10.0)
- Conda or Mamba
- 16 GB RAM (32 GB recommended)

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
Usage
Basic Run
bash
nextflow run main.nf --input reads.fastq -profile conda
With Custom Parameters
bash
nextflow run main.nf \
    --input reads.fastq \
    --outdir ./results \
    --min_read_length 500 \
    --min_read_quality 10 \
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
├── PHANOTATE/     # Gene predictions (542 proteins)
├── BLAST/         # Protein annotations (233 viral hits, 14 bacterial hits)
└── MULTIQC/       # Aggregated report
Assembly Details
Final Assembly (Polished)
After assembly and polishing, contig_5 was identified as the complete circular phage genome (61.8 kb, 699x coverage, 0 gaps). Additional contigs (contig_1-4) represent bacterial host fragments or prophage remnants integrated in the host chromosome.

Contig	Length	Coverage	Circular	Identity
contig_5	61.8 kb	699x	Yes	Phage (Pseudomonas Bf7-like)
contig_4	41.2 kb	5x	No	Bacterial fragment (S. aureus)
contig_3	39.3 kb	4x	No	Bacterial fragment + Pseudomonas prophage
contig_2	37.5 kb	2x	Yes	Phage-plasmid hybrid
contig_1	36.7 kb	4x	No	Bacterial fragment with Vibrio prophage
Assembly Metrics (QUAST)
Metric	Value
Number of contigs	5
Largest contig	61,841 bp
Total length	190,372 bp
N50	41,164 bp
L50	2
N's per 100 kbp	0
Notes
Medaka polishing only succeeds for high-coverage contigs (>50x)

The 500 bp read filter was intentionally set low to retain shorter bacterial fragments - this enabled identification of both the active phage and host-associated prophage sequences

The pipeline uses Chopper for read length/quality filtering (default: min 500 bp, min Q>=10)

License
MIT

Author
Evangelia Sklaveniti

Acknowledgments
Prof. Bas E. Dutilh, Viral Ecology and Omics Group, FSU Jena

Cluster of Excellence Balance of the Microverse

Repository
https://github.com/eya146/nanopore-bacterial-pipeline
