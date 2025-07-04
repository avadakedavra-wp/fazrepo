# fazrepo Installation Guide

This guide provides multiple ways to install fazrepo on different platforms.

## 🚀 Quick Install (Recommended)

### One-Line Install

**Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex"
```

**Windows (Git Bash/WSL/MSYS2):**
```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```

## 📋 Platform-Specific Instructions

### Linux

#### Ubuntu/Debian
```bash
# Using the install script (recommended)
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash

# Manual installation
wget https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-x86_64-unknown-linux-gnu
chmod +x fazrepo-x86_64-unknown-linux-gnu
sudo mv fazrepo-x86_64-unknown-linux-gnu /usr/local/bin/fazrepo
```

#### CentOS/RHEL/Fedora
```bash
# Using the install script (recommended)
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash

# Manual installation using curl
curl -L https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-x86_64-unknown-linux-gnu -o fazrepo
chmod +x fazrepo
sudo mv fazrepo /usr/local/bin/
```

#### Arch Linux
```bash
# Using AUR (if available)
yay -S fazrepo

# Or using the install script
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```

### macOS

#### Using Homebrew (Recommended)
```bash
brew tap avadakedavra-wp/fazrepo
brew install fazrepo
```

#### Using the Install Script
```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```

#### Manual Installation
```bash
# Intel Macs
curl -L https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-x86_64-apple-darwin -o fazrepo

# Apple Silicon Macs (M1/M2)
curl -L https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-aarch64-apple-darwin -o fazrepo

# Make executable and install
chmod +x fazrepo
sudo mv fazrepo /usr/local/bin/
```

### Windows

#### Using PowerShell (Recommended)
```powershell
powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex"
```

#### Using Git Bash/WSL/MSYS2
```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```

#### Manual Installation
1. Download `fazrepo-x86_64-pc-windows-msvc.exe` from [GitHub Releases](https://github.com/avadakedavra-wp/fazrepo/releases)
2. Rename to `fazrepo.exe`
3. Place in a directory in your PATH (e.g., `C:\Users\YourName\.local\bin\`)
4. Add the directory to your PATH if needed

#### Using Chocolatey (if available)
```cmd
choco install fazrepo
```

#### Using Scoop (if available)
```cmd
scoop bucket add extras
scoop install fazrepo
```

## 🔧 Advanced Installation

### Install from Source

**Prerequisites:**
- Git
- Rust toolchain (install from [rustup.rs](https://rustup.rs/))

```bash
# Clone the repository
git clone https://github.com/avadakedavra-wp/fazrepo.git
cd fazrepo/apps/cli

# Build in release mode
cargo build --release

# Install locally
cp target/release/fazrepo ~/.local/bin/  # Linux/macOS
# or
copy target\release\fazrepo.exe %USERPROFILE%\.local\bin\  # Windows
```

### Install via Cargo
```bash
cargo install --git https://github.com/avadakedavra-wp/fazrepo
```

### Docker Usage
```bash
# Run without installing
docker run --rm -it ghcr.io/avadakedavra-wp/fazrepo:latest check

# Create an alias for convenience
alias fazrepo="docker run --rm -it ghcr.io/avadakedavra-wp/fazrepo:latest"
```

## 📦 Binary Downloads

### Direct Download Links

| Platform | Architecture | Download Link |
|----------|-------------|---------------|
| Linux | x86_64 | [fazrepo-x86_64-unknown-linux-gnu](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-x86_64-unknown-linux-gnu) |
| Linux | ARM64 | [fazrepo-aarch64-unknown-linux-gnu](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-aarch64-unknown-linux-gnu) |
| macOS | Intel | [fazrepo-x86_64-apple-darwin](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-x86_64-apple-darwin) |
| macOS | Apple Silicon | [fazrepo-aarch64-apple-darwin](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-aarch64-apple-darwin) |
| Windows | x86_64 | [fazrepo-x86_64-pc-windows-msvc.exe](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-x86_64-pc-windows-msvc.exe) |

### Zip Archives
For convenience, you can also download zip archives containing the binary:

| Platform | Download |
|----------|----------|
| Linux (x64) | [fazrepo-linux-x64.zip](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-linux-x64.zip) |
| macOS (Intel) | [fazrepo-macos-intel.zip](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-macos-intel.zip) |
| macOS (Apple Silicon) | [fazrepo-macos-arm64.zip](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-macos-arm64.zip) |
| Windows (x64) | [fazrepo-windows-x64.zip](https://github.com/avadakedavra-wp/fazrepo/releases/latest/download/fazrepo-windows-x64.zip) |

## ✅ Verify Installation

After installation, verify that fazrepo is working:

```bash
# Check if fazrepo is in PATH
fazrepo --version

# Test basic functionality
fazrepo check

# Initialize in a project directory
fazrepo init
```

## 🔧 Troubleshooting

### Common Issues

#### "fazrepo: command not found"
1. Restart your terminal
2. Check if the binary is in your PATH:
   ```bash
   # Linux/macOS
   echo $PATH
   which fazrepo
   
   # Windows
   echo $env:PATH
   where.exe fazrepo
   ```
3. Add the installation directory to your PATH

#### Permission Denied (Linux/macOS)
```bash
chmod +x /path/to/fazrepo
```

#### PowerShell Execution Policy (Windows)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Installation Directory
The install scripts place binaries in:
- **Linux/macOS**: `~/.local/bin/fazrepo`
- **Windows**: `%USERPROFILE%\.local\bin\fazrepo.exe`

### Manual PATH Configuration

#### Linux/macOS
Add to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):
```bash
export PATH="$PATH:$HOME/.local/bin"
```

#### Windows
Add `%USERPROFILE%\.local\bin` to your user PATH environment variable:
1. Open "Environment Variables" in Windows settings
2. Edit the user PATH variable
3. Add `%USERPROFILE%\.local\bin`
4. Restart your terminal

## 🆘 Getting Help

If you encounter issues:

1. Check the [FAQ](FAQ.md)
2. Search [existing issues](https://github.com/avadakedavra-wp/fazrepo/issues)
3. Create a [new issue](https://github.com/avadakedavra-wp/fazrepo/issues/new) with:
   - Your operating system and version
   - Installation method used
   - Complete error message
   - Output of `echo $PATH` (Linux/macOS) or `echo $env:PATH` (Windows)

---

**Need help?** Join our [Discord](https://discord.gg/fazrepo) or check the [documentation](https://fazrepo.dev/docs).
