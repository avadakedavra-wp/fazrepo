#!/bin/bash

# fazrepo development installation script
# For when there are no releases yet
# Usage: curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install-dev.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO="avadakedavra-wp/fazrepo"
BINARY_NAME="fazrepo"
INSTALL_DIR="/usr/local/bin"

echo -e "${BLUE}🚀 Installing fazrepo from source...${NC}"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git not found${NC}"
    echo -e "${YELLOW}💡 Please install git first${NC}"
    exit 1
fi

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}❌ Rust/Cargo not found${NC}"
    echo -e "${YELLOW}💡 Installing Rust...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    
    if ! command -v cargo &> /dev/null; then
        echo -e "${RED}❌ Failed to install Rust${NC}"
        echo -e "${YELLOW}💡 Please install Rust manually from https://rustup.rs/${NC}"
        exit 1
    fi
fi

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo -e "${YELLOW}📦 Cloning repository...${NC}"
if ! git clone "https://github.com/$REPO.git" fazrepo; then
    echo -e "${RED}❌ Failed to clone repository${NC}"
    echo -e "${YELLOW}💡 Make sure the repository exists and is public${NC}"
    exit 1
fi

cd fazrepo

echo -e "${YELLOW}🔨 Building from source...${NC}"
cargo build --release

BINARY_PATH="target/release/$BINARY_NAME"

# Make binary executable
chmod +x "$BINARY_PATH"

# Check if we need sudo for installation
if [ ! -w "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}🔐 Need sudo to install to $INSTALL_DIR${NC}"
    sudo cp "$BINARY_PATH" "$INSTALL_DIR/"
else
    cp "$BINARY_PATH" "$INSTALL_DIR/"
fi

# Cleanup
cd /
rm -rf "$TMP_DIR"

# Verify installation
if command -v $BINARY_NAME &> /dev/null; then
    echo -e "${GREEN}✅ $BINARY_NAME installed successfully!${NC}"
    echo -e "${BLUE}📍 Location: $(which $BINARY_NAME)${NC}"
    echo -e "${BLUE}🎯 Version: $($BINARY_NAME --version)${NC}"
    echo ""
    echo -e "${GREEN}🎉 You can now run: $BINARY_NAME${NC}"
    echo -e "${BLUE}💡 Try: $BINARY_NAME check${NC}"
else
    echo -e "${RED}❌ Installation failed. $BINARY_NAME not found in PATH${NC}"
    echo -e "${YELLOW}💡 Try adding $INSTALL_DIR to your PATH${NC}"
    exit 1
fi
