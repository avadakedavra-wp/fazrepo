# fazrepo PowerShell installation script for Windows
# Usage: powershell -c "irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex"

param(
    [string]$InstallDir = "$env:USERPROFILE\bin",
    [string]$Version = "latest"
)

$ErrorActionPreference = "Stop"

# Configuration
$Repo = "avadakedavra-wp/fazrepo"
$BinaryName = "fazrepo"

# Colors for output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Info($msg) { Write-ColorOutput Cyan "🚀 $msg" }
function Write-Success($msg) { Write-ColorOutput Green "✅ $msg" }
function Write-Warning($msg) { Write-ColorOutput Yellow "⚠️  $msg" }
function Write-Error($msg) { Write-ColorOutput Red "❌ $msg" }

Write-Info "Installing fazrepo for Windows..."

# Detect architecture
$Arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else { "i686" }
$Target = "$Arch-pc-windows-msvc"

Write-Info "Detected architecture: $Arch"

try {
    # Get latest release info
    if ($Version -eq "latest") {
        Write-Info "Fetching latest release information..."
        $ReleaseInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest"
        $Version = $ReleaseInfo.tag_name
    }
    
    Write-Info "Version: $Version"
    
    # Download URL
    $DownloadUrl = "https://github.com/$Repo/releases/download/$Version/$BinaryName-$Target.exe"
    $TempPath = [System.IO.Path]::GetTempPath()
    $BinaryPath = Join-Path $TempPath "$BinaryName.exe"
    
    Write-Info "Downloading from $DownloadUrl..."
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $BinaryPath -UseBasicParsing
    
    # Create install directory if it doesn't exist
    if (!(Test-Path $InstallDir)) {
        Write-Info "Creating install directory: $InstallDir"
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }
    
    # Install binary
    $FinalPath = Join-Path $InstallDir "$BinaryName.exe"
    Move-Item $BinaryPath $FinalPath -Force
    
    Write-Success "$BinaryName installed to $FinalPath"
    
    # Check if install directory is in PATH
    $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($CurrentPath -notlike "*$InstallDir*") {
        Write-Warning "Adding $InstallDir to your PATH..."
        $NewPath = "$CurrentPath;$InstallDir"
        [Environment]::SetEnvironmentVariable("PATH", $NewPath, "User")
        Write-Info "PATH updated. Restart your terminal or run: refreshenv"
    }
    
    # Verify installation
    Write-Info "Verifying installation..."
    if (Test-Path $FinalPath) {
        Write-Success "Installation successful!"
        Write-Info "Location: $FinalPath"
        
        # Try to get version
        try {
            $VersionOutput = & $FinalPath --version
            Write-Info "Version: $VersionOutput"
        }
        catch {
            Write-Warning "Could not verify version. You may need to restart your terminal."
        }
        
        Write-Success "You can now run: fazrepo"
        Write-Info "Try: fazrepo check"
    }
    else {
        Write-Error "Installation failed. Binary not found at $FinalPath"
        exit 1
    }
}
catch {
    if ($_.Exception.Message -like "*404*") {
        Write-Error "Release not found. The version '$Version' may not exist."
        Write-Warning "You can install from source using:"
        Write-Info "git clone https://github.com/$Repo.git"
        Write-Info "cd fazrepo"
        Write-Info "cargo build --release"
    }
    else {
        Write-Error "Installation failed: $($_.Exception.Message)"
    }
    exit 1
}
