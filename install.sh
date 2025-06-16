#!/bin/bash

# fazrepo installation script
# Usage: curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/master/install.sh | bash

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

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    arm64|aarch64)
        ARCH="aarch64"
        ;;
    *)
        echo -e "${RED}❌ Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

case $OS in
    linux)
        TARGET="$ARCH-unknown-linux-gnu"
        ;;
    darwin)
        TARGET="$ARCH-apple-darwin"
        ;;
    *)
        echo -e "${RED}❌ Unsupported OS: $OS${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}🚀 Installing fazrepo...${NC}"

# Get the latest release
echo -e "${YELLOW}📡 Checking for latest release...${NC}"
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' 2>/dev/null || echo "")

if [ -z "$LATEST_RELEASE" ]; then
    echo -e "${YELLOW}⚠️  No releases found. Installing from source...${NC}"
    
    # Fallback: install from source
    echo -e "${BLUE}📦 Cloning repository...${NC}"
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    
    if ! git clone "https://github.com/$REPO.git" fazrepo; then
        echo -e "${RED}❌ Failed to clone repository${NC}"
        echo -e "${YELLOW}💡 Make sure the repository exists and is public${NC}"
        echo -e "${YELLOW}💡 Or install Rust and build from source manually${NC}"
        exit 1
    fi
    
    cd fazrepo
    
    # Check if Rust is installed
    if ! command -v cargo &> /dev/null; then
        echo -e "${RED}❌ Rust/Cargo not found${NC}"
        echo -e "${YELLOW}💡 Please install Rust from https://rustup.rs/${NC}"
        echo -e "${YELLOW}💡 Then run: cargo install --git https://github.com/$REPO${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}🔨 Building from source...${NC}"
    cargo build --release
    
    BINARY_PATH="target/release/$BINARY_NAME"
else
    echo -e "${YELLOW}📦 Latest version: $LATEST_RELEASE${NC}"
    
    # Download URL
    DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/${BINARY_NAME}-$TARGET"
    
    # Create temporary directory
    TMP_DIR=$(mktemp -d)
    BINARY_PATH="$TMP_DIR/$BINARY_NAME"
    
    echo -e "${YELLOW}⬇️  Downloading $BINARY_NAME for $TARGET...${NC}"
    
    # Download the binary
    if ! curl -sL "$DOWNLOAD_URL" -o "$BINARY_PATH"; then
        echo -e "${RED}❌ Failed to download $BINARY_NAME${NC}"
        echo -e "${YELLOW}💡 You may need to install from source or check if the release exists${NC}"
        exit 1
    fi
fi

# Make binary executable
chmod +x "$BINARY_PATH"

# Check if we need sudo for installation
if [ ! -w "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}🔐 Need sudo to install to $INSTALL_DIR${NC}"
    sudo mv "$BINARY_PATH" "$INSTALL_DIR/"
else
    mv "$BINARY_PATH" "$INSTALL_DIR/"
fi

# Cleanup
rm -rf "$TMP_DIR"

# Verify installation
if command -v $BINARY_NAME &> /dev/null; then
    echo -e "${GREEN}✅ $BINARY_NAME installed successfully!${NC}"
    echo -e "${BLUE}📍 Location: $(which $BINARY_NAME)${NC}"
    echo -e "${BLUE}🎯 Version: $($BINARY_NAME --version)${NC}"
    echo ""
    echo -e "${GREEN}🎉 You can now run: $BINARY_NAME${NC}"
else
    echo -e "${RED}❌ Installation failed. $BINARY_NAME not found in PATH${NC}"
    echo -e "${YELLOW}💡 Try adding $INSTALL_DIR to your PATH${NC}"
    exit 1
fi
