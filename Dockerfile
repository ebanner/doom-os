# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 debian:bookworm-slim

# Install build tools, assembler, 32-bit support, and debugging utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc-multilib \
    nasm \
    binutils \
    gdb-multiarch \
    gdbserver \
    util-linux \
    file \
    procps \
    strace \
    vim \
    less \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

CMD ["/bin/bash"]
