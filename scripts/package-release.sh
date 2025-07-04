#!/bin/bash

# Script to create release packages and zip files for fazrepo
# Usage: ./scripts/package-release.sh <version>

set -e

VERSION=${1:-"latest"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RELEASE_DIR="$PROJECT_ROOT/release-assets"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📦 Creating release packages for fazrepo v$VERSION${NC}"

# Create release directory
mkdir -p "$RELEASE_DIR"

# Build targets
TARGETS=(
    "x86_64-unknown-linux-gnu"
    "aarch64-unknown-linux-gnu"
    "x86_64-apple-darwin"
    "aarch64-apple-darwin"
    "x86_64-pc-windows-msvc"
)

# Friendly names for zip files
declare -A FRIENDLY_NAMES=(
    ["x86_64-unknown-linux-gnu"]="linux-x64"
    ["aarch64-unknown-linux-gnu"]="linux-arm64"
    ["x86_64-apple-darwin"]="macos-intel"
    ["aarch64-apple-darwin"]="macos-arm64"
    ["x86_64-pc-windows-msvc"]="windows-x64"
)

cd "$PROJECT_ROOT/apps/cli"

echo -e "${YELLOW}🔨 Building binaries...${NC}"

for target in "${TARGETS[@]}"; do
    echo -e "${BLUE}Building for $target...${NC}"
    
    # Determine binary extension
    if [[ $target == *"windows"* ]]; then
        BINARY_EXT=".exe"
    else
        BINARY_EXT=""
    fi
    
    # Build for target
    if cargo build --release --target "$target"; then
        echo -e "${GREEN}✅ Built $target${NC}"
        
        # Copy binary to release directory
        BINARY_NAME="fazrepo-$target$BINARY_EXT"
        cp "target/$target/release/fazrepo$BINARY_EXT" "$RELEASE_DIR/$BINARY_NAME"
        
        # Create zip package
        FRIENDLY_NAME="${FRIENDLY_NAMES[$target]}"
        ZIP_NAME="fazrepo-$FRIENDLY_NAME.zip"
        
        echo -e "${YELLOW}📦 Creating $ZIP_NAME...${NC}"
        
        cd "$RELEASE_DIR"
        
        # Create a temporary directory for the zip contents
        ZIP_DIR="fazrepo-$FRIENDLY_NAME"
        mkdir -p "$ZIP_DIR"
        
        # Copy binary
        cp "$BINARY_NAME" "$ZIP_DIR/fazrepo$BINARY_EXT"
        
        # Create README for the zip
        cat > "$ZIP_DIR/README.txt" << EOF
fazrepo v$VERSION

A blazing-fast CLI tool to check package manager versions.

Installation:
1. Extract this archive
2. Place 'fazrepo$BINARY_EXT' in your PATH
3. Make it executable (Linux/macOS): chmod +x fazrepo
4. Run: fazrepo --version

Usage:
  fazrepo check          # Check all package managers
  fazrepo check --detailed  # Detailed information
  fazrepo list           # List supported managers
  fazrepo --help         # Show help

Documentation: https://github.com/avadakedavra-wp/fazrepo
EOF
        
        # Create the zip file
        if command -v zip >/dev/null 2>&1; then
            zip -r "$ZIP_NAME" "$ZIP_DIR" >/dev/null
        else
            echo -e "${YELLOW}⚠️  'zip' command not found, skipping zip creation${NC}"
        fi
        
        # Cleanup
        rm -rf "$ZIP_DIR"
        
        cd "$PROJECT_ROOT/apps/cli"
        
        echo -e "${GREEN}✅ Created $ZIP_NAME${NC}"
    else
        echo -e "${RED}❌ Failed to build $target${NC}"
    fi
done

echo -e "${GREEN}🎉 Release packaging complete!${NC}"
echo -e "${BLUE}📁 Release files are in: $RELEASE_DIR${NC}"

# List created files
echo -e "${YELLOW}📋 Created files:${NC}"
ls -la "$RELEASE_DIR" | grep -E "(fazrepo-|\.zip)" | while read -r line; do
    echo -e "${BLUE}  $line${NC}"
done

# Generate checksums
echo -e "${YELLOW}🔐 Generating checksums...${NC}"
cd "$RELEASE_DIR"

if command -v sha256sum >/dev/null 2>&1; then
    sha256sum fazrepo-* > SHA256SUMS
    echo -e "${GREEN}✅ SHA256 checksums created${NC}"
elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 fazrepo-* > SHA256SUMS
    echo -e "${GREEN}✅ SHA256 checksums created${NC}"
else
    echo -e "${YELLOW}⚠️  No SHA256 utility found, skipping checksums${NC}"
fi

echo -e "${GREEN}✨ All done! Release v$VERSION is ready.${NC}"
