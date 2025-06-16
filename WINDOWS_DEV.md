# 🛠️ fazrepo Windows Development Guide

This guide covers developing and building fazrepo on Windows.

## 🔧 Development Environment Setup

### Prerequisites

1. **Install Rust**
   ```powershell
   # Using winget (recommended)
   winget install --id Rust.Rustup
   
   # Or download from: https://rustup.rs/
   ```

2. **Install Git**
   ```powershell
   winget install --id Git.Git
   ```

3. **Install Visual Studio Build Tools** (for MSVC compiler)
   ```powershell
   winget install --id Microsoft.VisualStudio.2022.BuildTools
   ```

4. **Install Windows Terminal** (optional but recommended)
   ```powershell
   winget install --id Microsoft.WindowsTerminal
   ```

### Clone and Build

```powershell
# Clone the repository
git clone https://github.com/avadakedavra-wp/fazrepo.git
cd fazrepo

# Build debug version
cargo build

# Build release version
cargo build --release

# Run tests
cargo test
```

## 🎯 Windows-Specific Development

### Cross-Compilation Setup

```powershell
# Add Windows targets
rustup target add x86_64-pc-windows-msvc
rustup target add aarch64-pc-windows-msvc

# Build for different Windows architectures
cargo build --release --target x86_64-pc-windows-msvc
cargo build --release --target aarch64-pc-windows-msvc
```

### Testing on Windows

```powershell
# Run all tests
cargo test

# Test Windows-specific functionality
.\target\release\fazrepo.exe check
.\target\release\fazrepo.exe --version

# Test with different package managers
.\target\release\fazrepo.exe check --only npm
.\target\release\fazrepo.exe check --detailed
```

### Debugging Windows Issues

```powershell
# Enable debug logging
$env:RUST_LOG = "debug"
.\target\debug\fazrepo.exe check

# Check for Windows-specific paths
.\target\debug\fazrepo.exe check --detailed
```

## 📦 Package Manager Testing

### Install Package Managers for Testing

```powershell
# Install Node.js (includes npm)
winget install --id OpenJS.NodeJS

# Install Yarn
npm install -g yarn

# Install pnpm
npm install -g pnpm

# Install Bun
powershell -c "irm bun.sh/install.ps1 | iex"
```

### Test Detection

```powershell
# Verify all are detected
.\target\release\fazrepo.exe check

# Test individual detection
where.exe npm
where.exe yarn
where.exe pnpm
where.exe bun
```

## 🔍 Windows-Specific Code Paths

### Key Windows Adaptations

1. **Command Detection** (`src/main.rs`)
   ```rust
   // Tries multiple variants on Windows
   let commands_to_try = if cfg!(target_os = "windows") {
       vec![
           format!("{}.cmd", command),
           format!("{}.exe", command),
           command.to_string(),
       ]
   } else {
       vec![command.to_string()]
   };
   ```

2. **Version Command Execution**
   ```rust
   // Uses cmd.exe wrapper for .cmd files
   let mut cmd = if cfg!(target_os = "windows") && !command.ends_with(".exe") {
       let mut c = Command::new("cmd");
       c.args(["/C", command, "--version"]);
       c
   } else {
       let mut c = Command::new(command);
       c.arg("--version");
       c
   };
   ```

3. **Path Handling**
   - Automatic Windows path separator handling
   - Support for spaces in paths
   - Windows environment variable expansion

## 🧪 Testing Changes

### Unit Tests

```powershell
# Run unit tests
cargo test --lib

# Run with output
cargo test --lib -- --nocapture
```

### Integration Tests

```powershell
# Run integration tests
cargo test --test integration_tests

# Test specific functionality
cargo test test_cli_help
cargo test test_version_command
```

### Manual Testing

```powershell
# Test help system
.\target\release\fazrepo.exe --help
.\target\release\fazrepo.exe check --help

# Test version detection
.\target\release\fazrepo.exe check --detailed

# Test error handling
.\target\release\fazrepo.exe check --only invalid_manager
```

## 📋 Build Scripts

### PowerShell Build Script

Create `build.ps1`:

```powershell
#!/usr/bin/env pwsh

param(
    [string]$Target = "x86_64-pc-windows-msvc",
    [switch]$Release
)

$BuildType = if ($Release) { "--release" } else { "" }

Write-Host "🔨 Building fazrepo for $Target..." -ForegroundColor Cyan

try {
    cargo build $BuildType --target $Target
    
    $BinaryPath = if ($Release) { 
        "target\$Target\release\fazrepo.exe" 
    } else { 
        "target\$Target\debug\fazrepo.exe" 
    }
    
    if (Test-Path $BinaryPath) {
        Write-Host "✅ Build successful!" -ForegroundColor Green
        Write-Host "📍 Binary: $BinaryPath" -ForegroundColor Blue
        
        # Test the binary
        & $BinaryPath --version
    } else {
        Write-Host "❌ Build failed - binary not found" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Build failed: $_" -ForegroundColor Red
    exit 1
}
```

### Test Script

Create `test.ps1`:

```powershell
#!/usr/bin/env pwsh

Write-Host "🧪 Running fazrepo tests on Windows..." -ForegroundColor Cyan

# Run Rust tests
Write-Host "Running cargo tests..." -ForegroundColor Yellow
cargo test

# Test binary functionality
Write-Host "Testing binary functionality..." -ForegroundColor Yellow
cargo build --release

$Binary = "target\release\fazrepo.exe"

if (Test-Path $Binary) {
    Write-Host "Testing version command..." -ForegroundColor Blue
    & $Binary --version
    
    Write-Host "Testing help command..." -ForegroundColor Blue
    & $Binary --help
    
    Write-Host "Testing check command..." -ForegroundColor Blue
    & $Binary check
    
    Write-Host "Testing list command..." -ForegroundColor Blue
    & $Binary list
    
    Write-Host "✅ All tests passed!" -ForegroundColor Green
} else {
    Write-Host "❌ Binary not found: $Binary" -ForegroundColor Red
    exit 1
}
```

## 📤 Release Process

### Building Release Binaries

```powershell
# Build all Windows targets
cargo build --release --target x86_64-pc-windows-msvc
cargo build --release --target aarch64-pc-windows-msvc

# Verify binaries
Get-ChildItem target\*\release\fazrepo.exe
```

### Testing Release

```powershell
# Test x64 binary
.\target\x86_64-pc-windows-msvc\release\fazrepo.exe check

# Test installation script
.\install.ps1
```

## 🐛 Common Issues and Solutions

### Build Issues

**Issue**: `link.exe` not found
```powershell
# Solution: Install Visual Studio Build Tools
winget install --id Microsoft.VisualStudio.2022.BuildTools
```

**Issue**: Rust not found after installation
```powershell
# Solution: Restart PowerShell or reload PATH
refreshenv
# Or restart your terminal
```

### Runtime Issues

**Issue**: Package managers not detected
```powershell
# Check PATH
$env:PATH -split ';' | Where-Object { $_ -like "*node*" }

# Verify installations
where.exe npm
where.exe yarn
where.exe pnpm
where.exe bun
```

**Issue**: Permission denied
```powershell
# Run as administrator or adjust execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Testing Issues

**Issue**: Tests fail on Windows
```powershell
# Run with verbose output
cargo test -- --nocapture

# Check Windows-specific test paths
cargo test --features windows-testing
```

## 💡 Development Tips

1. **Use PowerShell Core** (pwsh) instead of Windows PowerShell for better compatibility
2. **Enable Developer Mode** for symlink support and better development experience
3. **Use Windows Terminal** for better console experience with colors and Unicode
4. **Install PowerShell 7+** for modern PowerShell features
5. **Consider WSL2** for Linux-compatible development while testing Windows binaries

## 📚 Resources

- [Rust on Windows](https://forge.rust-lang.org/infra/platform-support.html#tier-1-with-host-tools)
- [Windows Terminal](https://github.com/Microsoft/Terminal)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)

Your Windows development environment for fazrepo is now ready! 🎯
