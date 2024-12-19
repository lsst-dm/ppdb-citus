FROM citusdata/citus:latest

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git gcc g++ make wget tar \
    postgresql-server-dev-16

# Download and build pgsphere
RUN wget https://github.com/postgrespro/pgsphere/archive/refs/tags/1.5.1.tar.gz && \
    tar -zxvf 1.5.1.tar.gz && \
    cd pgsphere-1.5.1 && \
    make USE_HEALPIX=0 && \
    make USE_HEALPIX=0 install && \
    cd / && rm -rf pgsphere-1.5.1 1.5.1.tar.gz

# Clean up unnecessary files and packages
RUN apt-get remove -y git gcc make wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
