#!/bin/bash

# fazrepo installation script
# Usage: curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO="avadakedavra-wp/fazrepo"
BINARY_NAME="fazrepo"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]' 2>/dev/null || echo "unknown")
ARCH=$(uname -m 2>/dev/null || echo "unknown")

# Handle Windows detection (for Git Bash, WSL, MSYS2, etc.)
if [[ "$OS" == "mingw"* ]] || [[ "$OS" == "msys"* ]] || [[ "$OS" == "cygwin"* ]]; then
    OS="windows"
fi

# Normalize architecture names
case $ARCH in
    x86_64|amd64)
        ARCH="x86_64"
        ;;
    arm64|aarch64)
        ARCH="aarch64"
        ;;
    armv7l)
        ARCH="armv7"
        ;;
    i386|i686)
        ARCH="i686"
        ;;
    *)
        echo -e "${RED}❌ Unsupported architecture: $ARCH${NC}"
        echo -e "${YELLOW}💡 Supported: x86_64, aarch64, armv7, i686${NC}"
        exit 1
        ;;
esac

# Set target and install directory based on OS
case $OS in
    linux)
        TARGET="$ARCH-unknown-linux-gnu"
        BINARY_EXT=""
        INSTALL_DIR="${HOME}/.local/bin"
        ;;
    darwin)
        TARGET="$ARCH-apple-darwin"
        BINARY_EXT=""
        INSTALL_DIR="${HOME}/.local/bin"
        ;;
    windows)
        TARGET="$ARCH-pc-windows-msvc"
        BINARY_EXT=".exe"
        INSTALL_DIR="${HOME}/bin"
        ;;
    *)
        echo -e "${RED}❌ Unsupported OS: $OS${NC}"
        echo -e "${YELLOW}💡 Supported: Linux, macOS, Windows${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}🚀 Installing fazrepo...${NC}"
echo -e "${YELLOW}📍 Target: $TARGET${NC}"
echo -e "${YELLOW}📂 Install directory: $INSTALL_DIR${NC}"

# Create install directory
mkdir -p "$INSTALL_DIR"

# Function to add directory to PATH
add_to_path() {
    local shell_config=""
    
    # Detect shell and config file
    case $SHELL in
        */bash)
            shell_config="$HOME/.bashrc"
            [ -f "$HOME/.bash_profile" ] && shell_config="$HOME/.bash_profile"
            ;;
        */zsh)
            shell_config="$HOME/.zshrc"
            ;;
        */fish)
            shell_config="$HOME/.config/fish/config.fish"
            mkdir -p "$(dirname "$shell_config")"
            ;;
        *)
            shell_config="$HOME/.profile"
            ;;
    esac
    
    # Check if PATH already contains our directory
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo -e "${YELLOW}📝 Adding $INSTALL_DIR to PATH in $shell_config${NC}"
        
        if [[ $SHELL == */fish ]]; then
            echo "set -gx PATH \$PATH $INSTALL_DIR" >> "$shell_config"
        else
            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$shell_config"
        fi
        
        # Also add to current session
        export PATH="$PATH:$INSTALL_DIR"
        
        echo -e "${YELLOW}💡 Please restart your terminal or run: source $shell_config${NC}"
    fi
}

# Function to install from release
install_from_release() {
    local version="$1"
    local download_url="https://github.com/$REPO/releases/download/$version/${BINARY_NAME}-$TARGET$BINARY_EXT"
    
    echo -e "${YELLOW}📦 Version: $version${NC}"
    echo -e "${YELLOW}⬇️  Downloading from GitHub releases...${NC}"
    
    # Create temporary file
    local tmp_file=$(mktemp)
    
    # Download with progress bar
    if command -v curl >/dev/null 2>&1; then
        if curl -fL --progress-bar "$download_url" -o "$tmp_file"; then
            echo -e "${GREEN}✅ Download successful${NC}"
        else
            echo -e "${RED}❌ Download failed${NC}"
            return 1
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget --progress=bar "$download_url" -O "$tmp_file"; then
            echo -e "${GREEN}✅ Download successful${NC}"
        else
            echo -e "${RED}❌ Download failed${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ Neither curl nor wget found${NC}"
        return 1
    fi
    
    # Install binary
    chmod +x "$tmp_file"
    mv "$tmp_file" "$INSTALL_DIR/$BINARY_NAME$BINARY_EXT"
    return 0
}

# Function to install from source
install_from_source() {
    echo -e "${YELLOW}🔨 Installing from source...${NC}"
    
    # Check if git is available
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${RED}❌ git is required for source installation${NC}"
        return 1
    fi
    
    # Check if Rust is installed
    if ! command -v cargo >/dev/null 2>&1; then
        echo -e "${RED}❌ Rust/Cargo not found${NC}"
        echo -e "${YELLOW}💡 Please install Rust from https://rustup.rs/${NC}"
        echo -e "${YELLOW}💡 Then run this script again${NC}"
        return 1
    fi
    
    # Clone and build
    local tmp_dir=$(mktemp -d)
    echo -e "${YELLOW}📦 Cloning repository...${NC}"
    
    if git clone --depth 1 "https://github.com/$REPO.git" "$tmp_dir"; then
        cd "$tmp_dir/apps/cli"
        echo -e "${YELLOW}⚙️  Building (this may take a few minutes)...${NC}"
        
        if cargo build --release; then
            cp "target/release/$BINARY_NAME$BINARY_EXT" "$INSTALL_DIR/"
            cd /
            rm -rf "$tmp_dir"
            echo -e "${GREEN}✅ Built and installed from source${NC}"
            return 0
        else
            echo -e "${RED}❌ Build failed${NC}"
            cd /
            rm -rf "$tmp_dir"
            return 1
        fi
    else
        echo -e "${RED}❌ Failed to clone repository${NC}"
        rm -rf "$tmp_dir"
        return 1
    fi
}

# Try to get latest release version
echo -e "${YELLOW}📡 Checking for latest release...${NC}"

if command -v curl >/dev/null 2>&1; then
    LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' 2>/dev/null || echo "")
elif command -v wget >/dev/null 2>&1; then
    LATEST_VERSION=$(wget -qO- "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' 2>/dev/null || echo "")
else
    echo -e "${RED}❌ Neither curl nor wget found${NC}"
    echo -e "${YELLOW}💡 Please install curl or wget to download releases${NC}"
    LATEST_VERSION=""
fi

# Install logic
if [ -n "$LATEST_VERSION" ]; then
    if install_from_release "$LATEST_VERSION"; then
        echo -e "${GREEN}✅ Installed from release${NC}"
    else
        echo -e "${YELLOW}⚠️  Release installation failed, trying source...${NC}"
        if ! install_from_source; then
            echo -e "${RED}❌ Both release and source installation failed${NC}"
            exit 1
        fi
    fi
else
    echo -e "${YELLOW}⚠️  No releases found or network error, installing from source...${NC}"
    if ! install_from_source; then
        echo -e "${RED}❌ Source installation failed${NC}"
        exit 1
    fi
fi

# Add to PATH
add_to_path

# Verify installation
echo -e "${BLUE}🧪 Verifying installation...${NC}"
if [ -f "$INSTALL_DIR/$BINARY_NAME$BINARY_EXT" ]; then
    chmod +x "$INSTALL_DIR/$BINARY_NAME$BINARY_EXT"
    
    if command -v "$BINARY_NAME" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ fazrepo is available in PATH${NC}"
        version_output=$("$BINARY_NAME" --version 2>/dev/null || echo "version check failed")
        echo -e "${BLUE}📍 Location: $(which "$BINARY_NAME")${NC}"
        echo -e "${BLUE}🎯 Version: $version_output${NC}"
    else
        echo -e "${YELLOW}⚠️  fazrepo not immediately available in PATH${NC}"
        echo -e "${YELLOW}👉 You can run it directly: $INSTALL_DIR/$BINARY_NAME$BINARY_EXT${NC}"
        version_output=$("$INSTALL_DIR/$BINARY_NAME$BINARY_EXT" --version 2>/dev/null || echo "version check failed")
        echo -e "${BLUE}🎯 Version: $version_output${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Installation complete!${NC}"
    echo -e "${BLUE}📘 Usage examples:${NC}"
    echo -e "  $BINARY_NAME --help"
    echo -e "  $BINARY_NAME check"
    echo -e "  $BINARY_NAME version"
    echo ""
    
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo -e "${YELLOW}💡 If '$BINARY_NAME' command is not found, restart your terminal${NC}"
    fi
else
    echo -e "${RED}❌ Installation failed. Binary not found at $INSTALL_DIR/$BINARY_NAME$BINARY_EXT${NC}"
    exit 1
fi
