#!/bin/bash

echo "================================================"
echo "ConfTainter Docker 运行脚本"
echo "================================================"
echo ""

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "错误: Docker 未安装"
    echo "请访问 https://www.docker.com/products/docker-desktop 安装 Docker Desktop"
    exit 1
fi

# 构建 Docker 镜像
echo "步骤 1: 构建 Docker 镜像（首次运行可能需要几分钟）..."
docker build -t conftainter:latest .

if [ $? -ne 0 ]; then
    echo "Docker 镜像构建失败"
    exit 1
fi

echo ""
echo "✓ Docker 镜像构建成功"
echo ""

# 运行容器
echo "步骤 2: 启动 Docker 容器..."
echo ""
echo "你现在将进入一个包含 LLVM 10 的容器环境"
echo ""
echo "在容器中运行以下命令来测试 ConfTainter:"
echo "  cd /workspace/src/test/demo"
echo "  clang++-10 -O0 -g -fno-discard-value-names -emit-llvm -c test.cpp -o test.bc"
echo "  ../../tainter test.bc test-var.txt"
echo "  cat test-records.dat"
echo ""
echo "按 Ctrl+D 或输入 'exit' 退出容器"
echo ""

docker run -it --rm \
    -v "$(pwd):/workspace" \
    conftainter:latest \
    /bin/bash

