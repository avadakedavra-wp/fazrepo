# 🚀 fazrepo Installation & Setup Guide

## Current Status & Quick Fix

You encountered the error:
```
❌ Failed to get latest release information
```

This is expected because **no GitHub releases exist yet**. Here's how to fix it:

## ✅ Immediate Solution (Development Install)

Use the development installer that builds from source:

```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/master/install-dev.sh | bash
```

This script will:
- Clone the repository
- Build from source using Cargo
- Install the binary to `/usr/local/bin`

## 📋 Complete Setup Process

### 1. First Time Setup

```bash
# Run the setup script to prepare everything
./setup.sh
```

### 2. Create GitHub Repository

1. Go to https://github.com/new
2. Create repository named `fazrepo`
3. Make it public
4. Don't initialize with README (you already have one)

### 3. Push Your Code

```bash
# Set the correct remote (replace with your actual repo URL)
git remote set-url origin https://github.com/avadakedavra-wp/fazrepo.git

# Push to GitHub
git push -u origin master
```

### 4. Create Your First Release

```bash
# This will create v0.1.0 release
./release.sh 0.1.0

# Push the tag
git push origin v0.1.0
```

### 5. Verify Everything Works

After creating the release, test both install methods:

```bash
# Development install (works now)
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/master/install-dev.sh | bash

# Release install (works after step 4)
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/master/install.sh | bash
```

## 🛠️ Troubleshooting

### Error: "Failed to get latest release information"
**Cause**: No GitHub releases exist yet  
**Solution**: Use development installer or create first release

### Error: "Failed to clone repository"
**Cause**: Repository doesn't exist or is private  
**Solution**: Create public GitHub repository and push code

### Error: "Rust/Cargo not found"
**Cause**: Rust toolchain not installed  
**Solution**: Install Rust from https://rustup.rs/

### Error: "Permission denied"
**Cause**: No write access to `/usr/local/bin`  
**Solution**: Script will automatically use `sudo`

## 📦 Alternative Installation Methods

### Local Build & Install
```bash
# Clone and build locally
git clone https://github.com/avadakedavra-wp/fazrepo.git
cd fazrepo
cargo build --release
sudo cp target/release/fazrepo /usr/local/bin/
```

### Using Cargo (after first release)
```bash
cargo install --git https://github.com/avadakedavra-wp/fazrepo
```

### Manual Binary Download (after release)
```bash
# Download binary directly from GitHub releases
wget https://github.com/avadakedavra-wp/fazrepo/releases/download/v0.1.0/fazrepo-x86_64-unknown-linux-gnu
chmod +x fazrepo-x86_64-unknown-linux-gnu
sudo mv fazrepo-x86_64-unknown-linux-gnu /usr/local/bin/fazrepo
```

## 🎯 Quick Test

After installation, verify fazrepo works:

```bash
fazrepo --version
fazrepo check
fazrepo list
```

Expected output:
```
🔍 Checking package manager versions...

✅ npm 10.9.0 (/path/to/npm)
❌ yarn not installed  
✅ pnpm 9.13.2 (/path/to/pnpm)
✅ bun 1.1.38 (/path/to/bun)
```

## 🚀 Next Steps

1. **Set up Homebrew tap** (optional):
   - Create repo: `avadakedavra-wp/homebrew-fazrepo`
   - Copy `homebrew-fazrepo/Formula/` directory there
   - Update SHA256 hash in formula after first release

2. **Automate releases**:
   - GitHub Actions will handle this automatically
   - Just push tags: `git push origin v0.1.1`

3. **Share your CLI**:
   - Add to your README or portfolio
   - Submit to package manager directories
   - Share on social media

Your fazrepo CLI is production-ready! 🎉
