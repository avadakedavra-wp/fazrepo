#!/bin/bash

# Test script to validate installation scripts locally
# This simulates the installation without actually installing

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🧪 Testing fazrepo installation scripts..."

# Test bash script syntax
echo "📋 Testing install.sh syntax..."
if bash -n "$PROJECT_ROOT/install.sh"; then
    echo "✅ install.sh syntax is valid"
else
    echo "❌ install.sh has syntax errors"
    exit 1
fi

# Test if scripts are executable
echo "📋 Checking script permissions..."
if [ -x "$PROJECT_ROOT/install.sh" ]; then
    echo "✅ install.sh is executable"
else
    echo "⚠️  install.sh is not executable"
    chmod +x "$PROJECT_ROOT/install.sh"
    echo "✅ Made install.sh executable"
fi

# Test script functionality with dry-run mode (if we implement it)
echo "📋 Testing script components..."

# Check if required commands exist for the script
REQUIRED_COMMANDS=("curl" "uname" "grep" "sed")
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd is available"
    else
        echo "⚠️  $cmd is not available (may cause issues)"
    fi
done

# Test architecture detection
echo "📋 Testing architecture detection..."
OS=$(uname -s | tr '[:upper:]' '[:lower:]' 2>/dev/null || echo "unknown")
ARCH=$(uname -m 2>/dev/null || echo "unknown")

echo "  Detected OS: $OS"
echo "  Detected ARCH: $ARCH"

case $ARCH in
    x86_64|amd64)
        echo "✅ Architecture $ARCH is supported"
        ;;
    arm64|aarch64)
        echo "✅ Architecture $ARCH is supported"
        ;;
    *)
        echo "⚠️  Architecture $ARCH may not be supported"
        ;;
esac

echo ""
echo "🎉 Installation script validation complete!"
echo ""
echo "📖 To test the actual installation (locally):"
echo "   ./install.sh"
echo ""
echo "📖 Installation URLs for users:"
echo "   Linux/macOS: curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash"
echo "   Windows:     powershell -ExecutionPolicy Bypass -c \"irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex\""
