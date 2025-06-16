# 🪟 Windows Installation Guide for fazrepo

This guide covers all the ways to install and use fazrepo on Windows.

## 🚀 Installation Methods

### Method 1: PowerShell (Recommended)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex
```

This will:
- ✅ Download the latest Windows binary
- ✅ Install to `%USERPROFILE%\bin`
- ✅ Add to your PATH automatically
- ✅ Verify the installation

### Method 2: Git Bash / WSL

If you're using Git Bash or Windows Subsystem for Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```

### Method 3: Manual Download

1. Go to [Releases](https://github.com/avadakedavra-wp/fazrepo/releases)
2. Download `fazrepo-x86_64-pc-windows-msvc.exe`
3. Rename to `fazrepo.exe`
4. Place in a directory in your PATH

### Method 4: From Source

```bash
# Install Rust first: https://rustup.rs/
git clone https://github.com/avadakedavra-wp/fazrepo.git
cd fazrepo
cargo build --release
copy target\release\fazrepo.exe C:\Users\%USERNAME%\bin\
```

## 🔧 Package Manager Support on Windows

fazrepo automatically detects Windows-specific command variations:

### Supported Package Managers

| Package Manager | Windows Command | Detection |
|----------------|----------------|-----------|
| **npm** | `npm.cmd` | ✅ Automatic |
| **yarn** | `yarn.cmd` | ✅ Automatic |
| **pnpm** | `pnpm.cmd` | ✅ Automatic |
| **bun** | `bun.exe` | ✅ Automatic |

### Command Examples

```powershell
# Check all package managers
fazrepo

# Check specific managers
fazrepo check --only npm,bun

# Detailed output with paths
fazrepo check --detailed

# List supported managers
fazrepo list
```

## 🛠️ Troubleshooting

### "fazrepo is not recognized as an internal or external command"

**Solution 1: Restart your terminal**
After installation, restart PowerShell/CMD to refresh the PATH.

**Solution 2: Add to PATH manually**
```powershell
$env:PATH += ";$env:USERPROFILE\bin"
```

**Solution 3: Use full path**
```powershell
& "$env:USERPROFILE\bin\fazrepo.exe" check
```

### Permission Issues

If you get permission errors:

```powershell
# Run PowerShell as Administrator, then:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Antivirus False Positives

Some antivirus software may flag the binary. This is common with new executables. You can:
1. Add an exception for fazrepo.exe
2. Install from source instead
3. Check the file hash against releases

### Package Managers Not Detected

**Common causes:**
- Package manager not in PATH
- Using PowerShell ISE (use regular PowerShell)
- Package manager installed via installer that doesn't add to PATH

**Solutions:**
```powershell
# Check your PATH
$env:PATH -split ';'

# Find npm location
where.exe npm

# Add Node.js to PATH if needed
$env:PATH += ";C:\Program Files\nodejs"
```

## 🎯 Windows-Specific Features

### Command Extensions

fazrepo automatically tries multiple command variants:
- `npm.cmd` (primary)
- `npm.exe` (fallback)
- `npm` (final fallback)

### Path Handling

- Uses Windows path separators automatically
- Supports both forward and backward slashes
- Handles spaces in paths correctly

### Environment Variables

Works with Windows environment variables:
- `%USERPROFILE%` for user directory
- `%PATH%` for executable search
- `%TEMP%` for temporary files

## 📦 Development on Windows

### Building from Source

```powershell
# Install Rust
winget install --id Rust.Rustup

# Clone and build
git clone https://github.com/avadakedavra-wp/fazrepo.git
cd fazrepo
cargo build --release
```

### Cross-compilation

```powershell
# Add Windows targets
rustup target add x86_64-pc-windows-msvc
rustup target add aarch64-pc-windows-msvc

# Build for Windows
cargo build --release --target x86_64-pc-windows-msvc
```

### Testing

```powershell
# Run tests
cargo test

# Test Windows-specific functionality
.\scripts\test-release.sh  # In Git Bash
```

## 🔗 Integration

### PowerShell Profile

Add fazrepo to your PowerShell profile:

```powershell
# Edit profile
notepad $PROFILE

# Add these lines:
function Check-PackageManagers { fazrepo check }
Set-Alias -Name pm -Value Check-PackageManagers
```

### Batch Scripts

Create a batch file for convenience:

```batch
@echo off
fazrepo %*
```

### Chocolatey (Future)

We're working on Chocolatey package support:

```powershell
# Coming soon:
choco install fazrepo
```

## 📋 Windows Requirements

- **OS**: Windows 10 or later
- **Architecture**: x64 (ARM64 support available)
- **Dependencies**: None (statically linked)
- **Permissions**: User-level (no admin required)

## 🎉 Success Verification

After installation, verify everything works:

```powershell
# Check version
fazrepo --version

# Test functionality
fazrepo check

# Expected output:
# 🔍 Checking package manager versions...
# 
# ✅ npm 10.9.0 (C:\Program Files\nodejs\npm.cmd)
# ❌ yarn not installed
# ✅ pnpm 9.13.2 (C:\Users\...\AppData\Roaming\npm\pnpm.cmd)
# ✅ bun 1.1.38 (C:\Users\...\.bun\bin\bun.exe)
```

## 💡 Tips for Windows Users

1. **Use PowerShell** instead of Command Prompt for better experience
2. **Install Windows Terminal** for better console experience
3. **Enable Developer Mode** for symlink support
4. **Use winget** for installing development tools
5. **Consider WSL2** for Linux-like development experience

Your fazrepo CLI is now ready for Windows! 🎯
