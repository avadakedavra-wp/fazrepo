# fazrepo PowerShell installation script for Windows
# Usage: powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex"

param(
    [string]$InstallDir = "$env:USERPROFILE\.local\bin",
    [string]$Version = "latest",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Configuration
$Repo = "avadakedavra-wp/fazrepo"
$BinaryName = "fazrepo.exe"

# Enhanced color output functions
function Write-ColorOutput {
    param(
        [Parameter(Mandatory)]
        [string]$Message,
        [Parameter(Mandatory)]
        [ConsoleColor]$Color
    )
    
    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Output $Message
    $Host.UI.RawUI.ForegroundColor = $originalColor
}

function Write-Info($msg) { Write-ColorOutput "🚀 $msg" Cyan }
function Write-Success($msg) { Write-ColorOutput "✅ $msg" Green }
function Write-Warning($msg) { Write-ColorOutput "⚠️  $msg" Yellow }
function Write-Error($msg) { Write-ColorOutput "❌ $msg" Red }
function Write-Step($msg) { Write-ColorOutput "📋 $msg" Blue }

# Function to test internet connectivity
function Test-InternetConnection {
    try {
        $null = Invoke-WebRequest -Uri "https://api.github.com" -Method Head -UseBasicParsing -TimeoutSec 10
        return $true
    }
    catch {
        return $false
    }
}

# Function to add directory to PATH
function Add-ToPath {
    param([string]$Directory)
    
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath -notlike "*$Directory*") {
        Write-Info "Adding $Directory to user PATH..."
        $newPath = if ($userPath) { "$userPath;$Directory" } else { $Directory }
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        $env:PATH = "$env:PATH;$Directory"
        Write-Success "PATH updated successfully"
        return $true
    }
    else {
        Write-Success "$Directory already in PATH"
        return $false
    }
}

# Function to install from GitHub releases
function Install-FromRelease {
    param([string]$Version)
    
    try {
        # Detect architecture
        $Arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else { "i686" }
        $Target = "$Arch-pc-windows-msvc"
        
        Write-Step "Target architecture: $Target"
        
        # Get release information
        if ($Version -eq "latest") {
            Write-Info "Fetching latest release information..."
            $releaseInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" -UseBasicParsing
            $Version = $releaseInfo.tag_name
        }
        
        Write-Info "Installing version: $Version"
        
        # Download URL
        $downloadUrl = "https://github.com/$Repo/releases/download/$Version/fazrepo-$Target.exe"
        $tempPath = Join-Path $env:TEMP $BinaryName
        
        Write-Info "Downloading from: $downloadUrl"
        Write-Info "This may take a moment..."
        
        # Download with progress
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($downloadUrl, $tempPath)
        $webClient.Dispose()
        
        Write-Success "Download completed"
        
        # Create install directory if it doesn't exist
        if (!(Test-Path $InstallDir)) {
            Write-Info "Creating install directory: $InstallDir"
            New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        }
        
        # Install binary
        $finalPath = Join-Path $InstallDir $BinaryName
        
        # Handle existing installation
        if (Test-Path $finalPath) {
            if ($Force) {
                Write-Warning "Overwriting existing installation (--Force specified)"
                Remove-Item $finalPath -Force
            }
            else {
                $overwrite = Read-Host "fazrepo is already installed. Overwrite? (y/N)"
                if ($overwrite -match '^[Yy]') {
                    Remove-Item $finalPath -Force
                }
                else {
                    Write-Warning "Installation cancelled by user"
                    Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
                    return $false
                }
            }
        }
        
        Move-Item $tempPath $finalPath -Force
        Write-Success "fazrepo installed to: $finalPath"
        
        return $true
    }
    catch {
        Write-Error "Failed to install from release: $($_.Exception.Message)"
        
        if ($_.Exception.Message -like "*404*") {
            Write-Warning "Release '$Version' not found. Available options:"
            Write-Info "- Check available releases at: https://github.com/$Repo/releases"
            Write-Info "- Try installing from source with Rust/Cargo"
        }
        
        # Cleanup temp file
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        }
        
        return $false
    }
}

# Function to install from source
function Install-FromSource {
    Write-Info "Installing from source..."
    
    # Check for required tools
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "Git is required for source installation"
        Write-Info "Download from: https://git-scm.com/download/windows"
        return $false
    }
    
    if (!(Get-Command cargo -ErrorAction SilentlyContinue)) {
        Write-Error "Rust/Cargo is required for source installation"
        Write-Info "Install from: https://rustup.rs/"
        return $false
    }
    
    try {
        # Create temporary directory
        $tempDir = Join-Path $env:TEMP "fazrepo-build-$(Get-Random)"
        Write-Info "Cloning repository to: $tempDir"
        
        # Clone repository
        git clone --depth 1 "https://github.com/$Repo.git" $tempDir
        if ($LASTEXITCODE -ne 0) {
            throw "Git clone failed"
        }
        
        # Build
        Push-Location (Join-Path $tempDir "apps\cli")
        Write-Info "Building fazrepo (this may take several minutes)..."
        cargo build --release
        if ($LASTEXITCODE -ne 0) {
            throw "Cargo build failed"
        }
        
        # Create install directory
        if (!(Test-Path $InstallDir)) {
            New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        }
        
        # Install binary
        $finalPath = Join-Path $InstallDir $BinaryName
        Copy-Item "target\release\fazrepo.exe" $finalPath -Force
        
        Pop-Location
        Remove-Item $tempDir -Recurse -Force
        
        Write-Success "Built and installed from source: $finalPath"
        return $true
    }
    catch {
        Write-Error "Source installation failed: $($_.Exception.Message)"
        
        # Cleanup
        if (Get-Location | Where-Object { $_.Path -like "*fazrepo-build*" }) {
            Pop-Location -ErrorAction SilentlyContinue
        }
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        return $false
    }
}

# Function to verify installation
function Test-Installation {
    $finalPath = Join-Path $InstallDir $BinaryName
    
    if (!(Test-Path $finalPath)) {
        Write-Error "Installation verification failed: Binary not found at $finalPath"
        return $false
    }
    
    Write-Step "Verifying installation..."
    
    try {
        $versionOutput = & $finalPath --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Installation verified successfully"
            Write-Info "Location: $finalPath"
            Write-Info "Version: $versionOutput"
            return $true
        }
        else {
            Write-Warning "Binary exists but version check failed: $versionOutput"
            return $false
        }
    }
    catch {
        Write-Warning "Could not verify installation: $($_.Exception.Message)"
        Write-Info "This might be normal - try restarting your terminal"
        return $false
    }
}

# Main installation logic
Write-Info "Installing fazrepo for Windows..."
Write-Step "Install directory: $InstallDir"

# Check internet connection
if (!(Test-InternetConnection)) {
    Write-Error "No internet connection detected"
    Write-Info "Please check your network connection and try again"
    exit 1
}

# Try installation from release first, fall back to source
$installSuccess = $false

if ($Version -eq "latest" -or $Version -match '^v?\d+\.\d+\.\d+') {
    Write-Step "Attempting installation from GitHub releases..."
    $installSuccess = Install-FromRelease -Version $Version
}

if (!$installSuccess) {
    Write-Warning "Release installation failed, trying source installation..."
    $installSuccess = Install-FromSource
}

if (!$installSuccess) {
    Write-Error "All installation methods failed"
    Write-Info "Manual installation options:"
    Write-Info "1. Download binary from: https://github.com/$Repo/releases"
    Write-Info "2. Install Rust and build from source: cargo install --git https://github.com/$Repo"
    exit 1
}

# Add to PATH
$pathChanged = Add-ToPath -Directory $InstallDir

# Verify installation
$verificationResult = Test-Installation

# Final instructions
Write-Success "🎉 Installation complete!"
Write-Info ""
Write-Step "Usage examples:"
Write-Output "  fazrepo --help"
Write-Output "  fazrepo check"
Write-Output "  fazrepo version"
Write-Info ""

if ($pathChanged -or !$verificationResult) {
    Write-Warning "You may need to restart your terminal/PowerShell for 'fazrepo' command to work"
    Write-Info "Alternatively, you can run it directly from: $(Join-Path $InstallDir $BinaryName)"
}

Write-Step "Quick test:"
Write-Output "  fazrepo check  # Check your package managers"

Write-Info "Installation completed successfully! 🚀"
