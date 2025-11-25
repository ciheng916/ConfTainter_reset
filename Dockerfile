# Dockerfile for ConfTainter with LLVM 10
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的工具和 LLVM 10
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    llvm-10 \
    llvm-10-dev \
    clang-10 \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /workspace

# 复制项目文件
COPY . /workspace/

# 编译 ConfTainter
WORKDIR /workspace/src
RUN rm -rf CMakeCache.txt CMakeFiles Makefile cmake_install.cmake tainter && \
    cmake \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++-10 \
    -DCMAKE_C_COMPILER=/usr/bin/clang-10 \
    -DLLVM_DIR=/usr/lib/llvm-10/cmake \
    . && \
    make

# 设置入口
WORKDIR /workspace/src/test/demo
CMD ["/bin/bash"]

