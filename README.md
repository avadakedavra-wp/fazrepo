# fazrepo

A fast CLI tool to check package manager versions on your system.

## Features

- 🚀 Check versions of npm, yarn, pnpm, and bun
- 🎨 Beautiful colored output
- ⚡ Fast and lightweight
- 🔧 Easy installation via Homebrew, curl, or PowerShell
- 🌍 Cross-platform support (Linux, macOS, Windows)

## Installation

### Windows (PowerShell)

```powershell
# Install via PowerShell (recommended for Windows)
irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex
```

### Quick Start (Development Install - All Platforms)

```bash
# Install from source (works immediately)
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install-dev.sh | bash
```

### Homebrew (macOS/Linux) - Coming Soon

```bash
brew tap avadakedavra-wp/fazrepo
brew install fazrepo
```

### Curl (Universal) - After First Release

```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/master/install.sh | bash
```

### From Source

```bash
git clone https://github.com/avadakedavra-wp/fazrepo.git
cd fazrepo
cargo build --release
sudo cp target/release/fazrepo /usr/local/bin/
```

## Usage

### Check all package managers

```bash
fazrepo
# or
fazrepo check
```

### Advanced options

```bash
# Check specific package managers only
fazrepo check --only npm,bun

# Show detailed information with full paths
fazrepo check --detailed

# List all supported package managers
fazrepo list
```

### Initialize fazrepo in current directory

```bash
fazrepo init
```

### Show version

```bash
fazrepo version
# or
fazrepo --version
```

### Windows-specific usage

```powershell
# PowerShell examples
fazrepo check
fazrepo check --only npm,pnpm
fazrepo list
```

## Sample Output

```
🔍 Checking package manager versions...

✅ npm 10.9.0 (/usr/local/bin/npm)
❌ yarn not installed
✅ pnpm 9.13.2 (/usr/local/bin/pnpm)
✅ bun 1.1.38 (/home/user/.bun/bin/bun)
```

## Package Managers Supported

fazrepo automatically detects package managers across all platforms:

- **npm** - Node Package Manager (detects `npm`, `npm.cmd` on Windows)
- **yarn** - Yet Another Resource Negotiator (detects `yarn`, `yarn.cmd` on Windows)  
- **pnpm** - Performant npm (detects `pnpm`, `pnpm.cmd` on Windows)
- **bun** - Bun JavaScript runtime and package manager (detects `bun`, `bun.exe` on Windows)

### Platform Support

- ✅ **Linux** (x86_64, ARM64)
- ✅ **macOS** (Intel, Apple Silicon)  
- ✅ **Windows** (x86_64, ARM64)

For Windows-specific installation and usage instructions, see [WINDOWS.md](WINDOWS.md).

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### v0.1.0
- Initial release
- Support for npm, yarn, pnpm, and bun
- Colorized output
- Installation scripts for multiple platforms
