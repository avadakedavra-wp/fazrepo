#!/bin/bash

# Development setup script for fazrepo monorepo
set -e

echo "🚀 Setting up fazrepo development environment..."

# Check for pnpm
if ! command -v pnpm &> /dev/null; then
    echo "❌ pnpm is required but not installed."
    echo "📦 Install pnpm: npm install -g pnpm"
    echo "   Or visit: https://pnpm.io/installation"
    exit 1
fi

# Check for Rust (for CLI development)
if ! command -v cargo &> /dev/null; then
    echo "⚠️  Rust is not installed. CLI development will not be available."
    echo "📦 Install Rust: https://rustup.rs/"
else
    echo "✅ Rust found: $(rustc --version)"
fi

echo "📦 Installing dependencies with pnpm..."
pnpm install

echo "🔨 Building packages..."
pnpm build

echo "✨ Setup complete!"
echo ""
echo "Available commands:"
echo "  pnpm dev        - Start all development servers"
echo "  pnpm web:dev    - Start web app (localhost:3000)"
echo "  pnpm docs:dev   - Start docs (localhost:3001)"
echo "  make build      - Build CLI"
echo "  make help       - Show all available commands"
echo ""
echo "🎉 Happy coding!"
