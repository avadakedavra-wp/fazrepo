#!/bin/bash

# Quick setup script for fazrepo
# This script helps you set up the repository and create your first release

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 fazrepo Setup Script${NC}"
echo -e "${BLUE}======================${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📝 Initializing git repository...${NC}"
    git init
    echo ""
fi

# Check if there are any commits
if ! git rev-parse HEAD &> /dev/null; then
    echo -e "${YELLOW}📝 Adding initial commit...${NC}"
    git add .
    git commit -m "Initial commit: fazrepo CLI tool"
    echo ""
fi

# Check if origin remote exists
if ! git remote get-url origin &> /dev/null; then
    echo -e "${YELLOW}🔗 Setting up remote origin...${NC}"
    echo -e "${BLUE}Please enter your GitHub repository URL:${NC}"
    echo -e "${BLUE}Example: https://github.com/avadakedavra-wp/fazrepo.git${NC}"
    read -p "Repository URL: " repo_url
    
    if [ -n "$repo_url" ]; then
        git remote add origin "$repo_url"
        echo -e "${GREEN}✅ Remote origin set to: $repo_url${NC}"
    else
        echo -e "${YELLOW}⚠️  Skipping remote setup${NC}"
    fi
    echo ""
fi

# Check if master branch exists
if git show-ref --verify --quiet refs/heads/master; then
    current_branch="master"
elif git show-ref --verify --quiet refs/heads/master; then
    current_branch="master"
else
    current_branch=$(git branch --show-current)
fi

echo -e "${BLUE}📋 Current Status:${NC}"
echo -e "  Branch: ${GREEN}$current_branch${NC}"
echo -e "  Remote: ${GREEN}$(git remote get-url origin 2>/dev/null || echo 'Not set')${NC}"
echo ""

# Build and test
echo -e "${YELLOW}🔨 Building and testing...${NC}"
cargo build --release
cargo test

echo -e "${GREEN}✅ Build and tests successful!${NC}"
echo ""

# Show next steps
echo -e "${BLUE}📋 Next Steps:${NC}"
echo -e "${YELLOW}1.${NC} Create GitHub repository (if not done already):"
echo -e "   Visit: https://github.com/new"
echo -e "   Name: fazrepo"
echo -e "   Description: A CLI tool to check package manager versions"
echo ""

echo -e "${YELLOW}2.${NC} Push your code:"
echo -e "   ${GREEN}git push -u origin $current_branch${NC}"
echo ""

echo -e "${YELLOW}3.${NC} Create your first release:"
echo -e "   ${GREEN}./release.sh 0.1.0${NC}"
echo -e "   ${GREEN}git push origin v0.1.0${NC}"
echo ""

echo -e "${YELLOW}4.${NC} Test installation methods:"
echo -e "   ${GREEN}# Development install (works now):${NC}"
echo -e "   curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/master/install-dev.sh | bash"
echo ""
echo -e "   ${GREEN}# Release install (after step 3):${NC}"
echo -e "   curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/master/install.sh | bash"
echo ""

echo -e "${YELLOW}5.${NC} Set up Homebrew tap (optional):"
echo -e "   Create repo: avadakedavra-wp/homebrew-fazrepo"
echo -e "   Copy homebrew-fazrepo/Formula/ directory there"
echo ""

echo -e "${GREEN}🎉 Your fazrepo CLI is ready for production!${NC}"
