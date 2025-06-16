#!/bin/bash

# fazrepo installation script
# Usage: curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash

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
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_RELEASE" ]; then
    echo -e "${RED}❌ Failed to get latest release information${NC}"
    exit 1
fi

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
