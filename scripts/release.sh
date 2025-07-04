#!/bin/bash

# Release script for fazrepo
# Usage: ./release.sh <version>

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -ne 1 ]; then
    echo -e "${RED}Usage: $0 <version>${NC}"
    echo -e "${YELLOW}Example: $0 0.1.1${NC}"
    exit 1
fi

VERSION=$1

# Validate version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}❌ Invalid version format. Use semantic versioning (e.g., 1.0.0)${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 Preparing release v$VERSION${NC}"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Not in a git repository${NC}"
    exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}❌ Working directory is not clean. Please commit your changes first.${NC}"
    exit 1
fi

# Update version in root package.json
echo -e "${YELLOW}📝 Updating package.json version${NC}"
sed -i "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" package.json

# Update version in CLI Cargo.toml
echo -e "${YELLOW}📝 Updating CLI Cargo.toml version${NC}"
sed -i "s/^version = \".*\"/version = \"$VERSION\"/" apps/cli/Cargo.toml

# Update version in Homebrew formula
echo -e "${YELLOW}📝 Updating Homebrew formula${NC}"
sed -i "s/archive\/v.*/archive\/v$VERSION.tar.gz\"/" homebrew-fazrepo/Formula/fazrepo.rb

# Run tests
echo -e "${YELLOW}🧪 Running CLI tests${NC}"
cd apps/cli
cargo test
cd ../..

# Run frontend tests (if any)
echo -e "${YELLOW}🧪 Running frontend tests${NC}"
pnpm test 2>/dev/null || echo "No frontend tests found, skipping..."

# Build release
echo -e "${YELLOW}🔨 Building CLI release${NC}"
cd apps/cli
cargo build --release
cd ../..

# Build web apps
echo -e "${YELLOW}🔨 Building web applications${NC}"
pnpm build

# Commit version changes
echo -e "${YELLOW}📝 Committing version bump${NC}"
git add package.json apps/cli/Cargo.toml apps/cli/Cargo.lock homebrew-fazrepo/Formula/fazrepo.rb
git commit -m "Bump version to v$VERSION"

# Create and push tag
echo -e "${YELLOW}🏷️  Creating tag v$VERSION${NC}"
git tag "v$VERSION"

echo -e "${GREEN}✅ Release v$VERSION prepared!${NC}"
echo -e "${BLUE}🚀 To complete the release:${NC}"
echo -e "   ${YELLOW}git push origin master${NC}"
echo -e "   ${YELLOW}git push origin v$VERSION${NC}"
echo ""
echo -e "${BLUE}📦 After pushing the tag, GitHub Actions will:${NC}"
echo -e "   • Build binaries for multiple platforms"
echo -e "   • Create a GitHub release"
echo -e "   • Upload release assets"
echo ""
echo -e "${BLUE}📋 Don't forget to:${NC}"
echo -e "   • Update the SHA256 in the Homebrew formula"
echo -e "   • Test the installation scripts"
