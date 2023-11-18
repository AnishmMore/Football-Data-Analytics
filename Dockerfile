FROM quay.io/astronomer/astro-runtime:9.4.0
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*
