#!/bin/bash

set -e

echo "🚀 Setting up FazRepo monorepo development environment..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ is required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js version: $(node -v)"

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    echo "❌ Rust is not installed. Please install Rust first."
    echo "Visit: https://rustup.rs/"
    exit 1
fi

echo "✅ Rust version: $(cargo --version)"

# Install pnpm if not installed
if ! command -v pnpm &> /dev/null; then
    echo "📦 Installing pnpm..."
    npm install -g pnpm
fi

echo "✅ pnpm version: $(pnpm --version)"

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install

# Build packages
echo "🔨 Building packages..."
pnpm build

echo "✅ Development environment setup complete!"
echo ""
echo "🎯 Available commands:"
echo "  pnpm dev          - Start all development servers"
echo "  pnpm web:dev      - Start web app (port 3000)"
echo "  pnpm docs:dev     - Start docs (port 3001)"
echo "  pnpm cli:build    - Build CLI"
echo "  pnpm test         - Run tests"
echo "  pnpm lint         - Run linting"
echo ""
echo "🌐 Access your apps:"
echo "  Web: http://localhost:3000"
echo "  Docs: http://localhost:3001" 