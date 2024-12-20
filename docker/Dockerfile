FROM citusdata/citus:latest

####################################################################################################
# Install pg_sphere extension with healpix support
####################################################################################################

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git gcc g++ make wget \
    postgresql-server-dev-16 \
    libcfitsio-dev

# Download and build healpix
RUN wget -O healpix.tar.gz "https://sourceforge.net/projects/healpix/files/Healpix_3.83/Healpix_3.83_2024Nov13.tar.gz/download" && \
    tar -zxvf healpix.tar.gz && \
    cd Healpix_3.83 && \
    FITSDIR=/usr/lib/x86_64-linux-gnu FITSINC=/usr/include ./configure --auto=sharp,cpp && \
    make && \
    cp -r include/healpix_cxx /usr/include/ && \
    cp -r lib/* /usr/lib/ && \
    cd / && rm -rf Healpix_3.83 healpix.tar.gz

# Download and build pgsphere
RUN wget https://github.com/postgrespro/pgsphere/archive/refs/tags/1.5.1.tar.gz && \
    tar -zxvf 1.5.1.tar.gz && \
    cd pgsphere-1.5.1 && \
    make CPPFLAGS="-I/usr/include/healpix_cxx" && \
    make install && \
    cd / && rm -rf pgsphere-1.5.1 1.5.1.tar.gz

# Clean up unnecessary files and packages
RUN apt-get remove -y git gcc make wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
