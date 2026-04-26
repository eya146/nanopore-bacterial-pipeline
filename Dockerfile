FROM continuumio/miniconda3:latest

LABEL maintainer="Evangelia Sklaveniti"
LABEL description="Nanopore Phage-Bacteria Assembly Pipeline"

WORKDIR /app

# Copy environment file
COPY environment.yml /app/environment.yml

# Create conda environment
RUN conda env create -f environment.yml && \
    conda clean --all -y

# Copy pipeline files
COPY main.nf nextflow.config ./
COPY modules/ ./modules/
COPY custom_db/ ./custom_db/

# Set entrypoint
SHELL ["conda", "run", "-n", "nanopore-pipeline", "/bin/bash", "-c"]

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "nanopore-pipeline", "nextflow"]

CMD ["run", "main.nf", "--help"]
