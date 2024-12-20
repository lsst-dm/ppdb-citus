FROM citusdata/citus:latest

# Define variables
ENV HEALPIX_DIR=/opt/healpix
ENV LD_LIBRARY_PATH=$HEALPIX_DIR/lib
ENV PKG_CONFIG_PATH=$HEALPIX_DIR/lib/pkgconfig
ENV CC=gcc CXX=g++

# Install dependencies
RUN apt-get update && apt-get install -y \
    git gcc g++ make wget pkg-config \
    postgresql-server-dev-16 libcfitsio-dev

# Build and install Healpix
RUN mkdir -p $HEALPIX_DIR && \
    cd $HEALPIX_DIR && \
    wget -O healpix.tar.gz "https://sourceforge.net/projects/healpix/files/Healpix_3.83/Healpix_3.83_2024Nov13.tar.gz/download" && \
    tar -zxvf healpix.tar.gz --strip-components=1 && \
    FITSDIR=/usr/lib/x86_64-linux-gnu FITSINC=/usr/include ./configure --auto=sharp,cpp && \
    make

# Build and install pg_sphere with Healpix support
RUN wget https://github.com/postgrespro/pgsphere/archive/refs/tags/1.5.1.tar.gz && \
    tar -zxvf 1.5.1.tar.gz && \
    cd pgsphere-1.5.1 && \
    make USE_HEALPIX=1 CXXFLAGS="-frtti" LDFLAGS="-L$HEALPIX_DIR/lib -lstdc++" && \
    make USE_HEALPIX=1 install && \
    cd / && rm -rf pgsphere-1.5.1 1.5.1.tar.gz

# Configure dynamic library paths
RUN echo "$HEALPIX_DIR/lib" > /etc/ld.so.conf.d/healpix.conf && ldconfig

# Set dynamic library path in PostgreSQL
RUN echo "SET dynamic_library_path TO '/usr/lib/postgresql/16/lib:/opt/healpix/lib';" > /docker-entrypoint-initdb.d/01-set-library-path.sql

# Verify linking of pg_sphere to Healpix
RUN ldd /usr/lib/postgresql/16/lib/pg_sphere.so | grep healpix || { echo "Healpix not linked properly!"; exit 1; }

# Clean up unnecessary files and packages
RUN apt-get remove -y git gcc make wget pkg-config && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
