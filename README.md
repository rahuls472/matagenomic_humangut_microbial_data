# 🧬 Metagenomics Analysis Pipeline using Nextflow

A modular **Nextflow DSL2 pipeline** for metagenomic sequencing data analysis. This workflow performs quality control, read preprocessing, taxonomic classification, and interactive visualization of paired-end metagenomic sequencing data.

---

## 🚀 Pipeline Overview

```text
Raw Paired-End Reads
        │
        ├──────────────► FASTQC
        │                 Raw Quality Control
        │
        ▼
      FASTP
Read Trimming & Filtering
        │
        ▼
     KRAKEN2
Taxonomic Classification
        │
        ▼
   Kraken2 Report
        │
        ▼
    KrakenTools
 kreport2krona.py
        │
        ▼
    Krona Input
        │
        ▼
   ktImportText
        │
        ▼
📊 Interactive Krona HTML
```

---

## 📋 Features

- Modular Nextflow DSL2 workflow
- Paired-end FASTQ input support
- Raw read quality control using FastQC
- Read trimming and filtering using Fastp
- Taxonomic classification using Kraken2
- Memory-efficient Kraken2 execution using memory mapping
- Kraken report conversion using KrakenTools
- Interactive taxonomic visualization using Krona
- Docker container support
- Reproducible workflow execution
- Nextflow caching using `-resume`

---

# 📁 Project Structure

```text
metagenomics/
│
├── data/
│   ├── SRR4481719_1.fastq
│   ├── SRR4481719_2.fastq
│   └── minikraken2_v2_8GB_201904_UPDATE/
│
├── modules/
│   ├── fastqc.nf
│   ├── fastp.nf
│   ├── kraken.nf
│   ├── kreport2krona.nf
│   └── krona.nf
│
├── Script/
│   └── KrakenTools/
│       ├── kreport2krona.py
│       └── other KrakenTools scripts
│
├── results/
│   ├── fastqc/
│   ├── fastp/
│   ├── kraken2/
│   ├── krona/
│   └── krona_results/
│
├── work/
│
├── .gitignore
├── .gitmodules
├── main.nf
├── nextflow.config
└── README.md
```

---

# 🔬 Workflow Steps

## 1. FastQC

FastQC performs quality control analysis on the raw sequencing reads.

It evaluates sequencing quality metrics such as:

- Per-base sequence quality
- GC content
- Sequence length distribution
- Adapter contamination
- Overrepresented sequences

---

## 2. Fastp

Fastp performs preprocessing of sequencing reads, including quality filtering and trimming.

```text
Raw Reads
    ↓
FASTP
    ↓
Trimmed Reads
```

Example output:

```text
trimmed_SRR4481719_R1.fastq
trimmed_SRR4481719_R2.fastq
```

---

## 3. Kraken2 Taxonomic Classification

Trimmed reads are classified using **Kraken2** against a Kraken2 database.

The pipeline uses:

```bash
--memory-mapping
```

Memory mapping allows Kraken2 to access its database using the operating system's memory-mapping mechanism, reducing RAM requirements compared with loading the complete database directly into memory.

### Output

```text
SRR4481719_kraken2_report.txt
SRR4481719_kraken2_output.txt
```

The Kraken2 report provides a hierarchical summary of the taxonomic classification results.

The Kraken2 output contains taxonomic assignments for individual sequencing reads.

---

## 4. Convert Kraken Report to Krona Format

The Kraken2 report is converted into a Krona-compatible format using the KrakenTools script:

```text
kreport2krona.py
```

Workflow:

```text
Kraken2 Report
       ↓
kreport2krona.py
       ↓
Krona Input File
```

---

## 5. Krona Visualization

The converted Krona input file is processed using:

```bash
ktImportText
```

The final output is:

```text
krona.html
```

The HTML file can be opened in a web browser for interactive exploration of the taxonomic composition of the metagenomic sample.

Users can explore the taxonomic hierarchy:

```text
Domain
  └── Phylum
       └── Class
            └── Order
                 └── Family
                      └── Genus
                           └── Species
```

---

# 🐳 Docker Support

The pipeline uses Docker containers to improve reproducibility.

Examples of containers used:

| Tool | Container |
|---|---|
| Fastp | Biocontainers Fastp image |
| Kraken2 | `staphb/kraken2:latest` |
| Python | `python:3.10` |
| Krona | `staphb/krona:latest` |

Docker execution is enabled in the Nextflow configuration:

```nextflow
docker {
    enabled = true
}
```

---

# ⚙️ Requirements

The following software should be installed:

- Nextflow
- Docker
- Git

Check the installations:

```bash
nextflow -version
docker --version
git --version
```

---

# 📥 Installation

Clone the repository:

```bash
git clone --recurse-submodules <YOUR_REPOSITORY_URL>
```

If the repository has already been cloned:

```bash
git submodule update --init --recursive
```

---

# 📂 Input Data

Place paired-end FASTQ files inside the `data/` directory.

Example:

```text
data/
├── sample_1.fastq
└── sample_2.fastq
```

The pipeline expects paired-end reads following the naming pattern:

```text
*_1.fastq
*_2.fastq
```

---

# 🗄️ Kraken2 Database

A Kraken2 database is required for taxonomic classification.

The database path is configured using Nextflow parameters:

```nextflow
params {

    data = "data/*_{1,2}.fastq"

    database = "data/minikraken2_v2_8GB_201904_UPDATE"

}
```

> **Note:** Kraken2 databases can be large and should generally not be uploaded to GitHub.

---

# ▶️ Running the Pipeline

Run the complete workflow:

```bash
nextflow run main.nf
```

If the workflow fails or is interrupted, continue using:

```bash
nextflow run main.nf -resume
```

The `-resume` option allows Nextflow to reuse successfully completed processes from the cache.

Example:

```text
FASTQC           cached ✔
FASTP            cached ✔
KRAKEN           cached ✔
KREPORT2KRONA    cached ✔
KRONA            runs
```

This prevents expensive processes such as Kraken2 classification from running again unnecessarily.

---

# 📊 Output

Results are generated inside the `results/` directory.

```text
results/
│
├── fastqc/
│   └── FastQC quality control reports
│
├── fastp/
│   └── Trimmed FASTQ files
│
├── kraken2/
│   ├── Kraken2 classification output
│   └── Kraken2 taxonomic report
│
├── krona/
│   └── Krona intermediate files
│
└── krona_results/
    └── krona.html
```

The final interactive visualization can be opened using:

```bash
firefox results/krona_results/krona.html
```

Or simply open `krona.html` in any modern web browser.

---

# 🧠 Nextflow Modules

The workflow is organized into reusable modules.

### `fastqc.nf`

Performs quality control on raw sequencing reads.

### `fastp.nf`

Performs read trimming and filtering.

### `kraken.nf`

Performs taxonomic classification using Kraken2.

### `kreport2krona.nf`

Converts the Kraken2 report into Krona-compatible format using KrakenTools.

### `krona.nf`

Generates the interactive Krona HTML visualization.

---

# 🛠️ Tools Used

- **Nextflow** — Workflow management
- **FastQC** — Sequencing quality control
- **Fastp** — FASTQ preprocessing
- **Kraken2** — Metagenomic taxonomic classification
- **KrakenTools** — Processing Kraken output
- **Krona** — Interactive visualization
- **Docker** — Containerized execution

---

# 📌 Reproducibility

This pipeline uses:

- Modular Nextflow DSL2 processes
- Docker containers
- Explicit input and output channels
- Git version control
- Git submodules for external dependencies
- Nextflow caching using `-resume`

These features make the workflow reproducible and portable across different systems.

---

# 👨‍💻 Author

**Rahul Kumar Singh**

Bioinformatics | NGS Data Analysis | Metagenomics | Nextflow Workflow Development

---

# 📜 License

This project is intended for educational and research purposes.

External tools and dependencies are distributed under their respective licenses.
