#!/bin/bash

# Update version in all relevant files for Windows support
# Usage: ./scripts/update-version.sh 1.2.3

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: Version argument required${NC}"
    echo -e "${BLUE}Usage: $0 <version>${NC}"
    echo -e "${BLUE}Example: $0 1.2.3${NC}"
    exit 1
fi

NEW_VERSION="$1"

# Validate version format (basic semver check)
if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?$'; then
    echo -e "${RED}❌ Error: Invalid version format${NC}"
    echo -e "${BLUE}Expected: MAJOR.MINOR.PATCH (e.g., 1.2.3)${NC}"
    exit 1
fi

echo -e "${BLUE}🔄 Updating version to ${GREEN}$NEW_VERSION${NC}"
echo ""

# Update Cargo.toml
echo -e "${YELLOW}📝 Updating Cargo.toml...${NC}"
sed -i "s/^version = \".*\"/version = \"$NEW_VERSION\"/" Cargo.toml
echo -e "${GREEN}✅ Cargo.toml updated${NC}"

# Update README.md version references
echo -e "${YELLOW}📝 Updating README.md...${NC}"
sed -i "s/fazrepo v[0-9]\+\.[0-9]\+\.[0-9]\+/fazrepo v$NEW_VERSION/g" README.md
echo -e "${GREEN}✅ README.md updated${NC}"

# Update Homebrew formula if it exists
if [ -f "homebrew-fazrepo/Formula/fazrepo.rb" ]; then
    echo -e "${YELLOW}📝 Updating Homebrew formula...${NC}"
    sed -i "s/version \".*\"/version \"$NEW_VERSION\"/" homebrew-fazrepo/Formula/fazrepo.rb
    echo -e "${GREEN}✅ Homebrew formula updated${NC}"
fi

# Update PowerShell installer
if [ -f "install.ps1" ]; then
    echo -e "${YELLOW}📝 Updating PowerShell installer...${NC}"
    sed -i "s/fazrepo v[0-9]\+\.[0-9]\+\.[0-9]\+/fazrepo v$NEW_VERSION/g" install.ps1
    echo -e "${GREEN}✅ PowerShell installer updated${NC}"
fi

# Update Windows documentation
if [ -f "WINDOWS.md" ]; then
    echo -e "${YELLOW}📝 Updating Windows documentation...${NC}"
    sed -i "s/fazrepo v[0-9]\+\.[0-9]\+\.[0-9]\+/fazrepo v$NEW_VERSION/g" WINDOWS.md
    echo -e "${GREEN}✅ Windows documentation updated${NC}"
fi

# Update CHANGELOG.md
echo -e "${YELLOW}📝 Updating CHANGELOG.md...${NC}"
CURRENT_DATE=$(date +"%Y-%m-%d")
sed -i "1i\\## [$NEW_VERSION] - $CURRENT_DATE\\n\\n### Added\\n- New release $NEW_VERSION\\n" CHANGELOG.md
echo -e "${GREEN}✅ CHANGELOG.md updated${NC}"

echo ""
echo -e "${GREEN}🎉 Version updated successfully to $NEW_VERSION${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Review changes: ${GREEN}git diff${NC}"
echo -e "2. Commit changes: ${GREEN}git add . && git commit -m \"Bump version to $NEW_VERSION\"${NC}"
echo -e "3. Create release: ${GREEN}./scripts/release.sh $NEW_VERSION${NC}"
