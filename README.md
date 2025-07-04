# FazRepo Monorepo

A blazing-fast CLI tool built in Rust to check package manager versions across npm, yarn, pnpm, and bun, with a beautiful web interface and comprehensive documentation.

## � Installation

### Quick Install (Recommended)

#### Linux/macOS (Bash/Zsh)
```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```

#### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.ps1 | iex"
```

#### Alternative for Windows (Command Prompt)
```cmd
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
```
*Note: Requires Git Bash, WSL, or MSYS2*

### Alternative Installation Methods

#### Package Managers
```bash
# Using Cargo (if you have Rust installed)
cargo install fazrepo

# Using Homebrew (macOS/Linux)
brew tap avadakedavra-wp/fazrepo
brew install fazrepo
```

#### Manual Download
1. Visit [GitHub Releases](https://github.com/avadakedavra-wp/fazrepo/releases)
2. Download the appropriate binary for your platform:
   - `fazrepo-x86_64-unknown-linux-gnu` (Linux x64)
   - `fazrepo-aarch64-unknown-linux-gnu` (Linux ARM64)
   - `fazrepo-x86_64-apple-darwin` (macOS Intel)
   - `fazrepo-aarch64-apple-darwin` (macOS Apple Silicon)
   - `fazrepo-x86_64-pc-windows-msvc.exe` (Windows x64)
3. Place it in your PATH and make it executable

#### Build from Source
```bash
git clone https://github.com/avadakedavra-wp/fazrepo.git
cd fazrepo/apps/cli
cargo build --release
# Binary will be at target/release/fazrepo
```

## 🚀 Quick Start

### Verify Installation
```bash
fazrepo --version
fazrepo check
```

### Basic Usage

```bash
# Initialize fazrepo (creates config file)
fazrepo init

# Check all package managers
fazrepo check

# Check with detailed information
fazrepo check --detailed

# Check only specific managers
fazrepo check --only npm,yarn

# List all supported package managers
fazrepo list

# Show version information
fazrepo version
```

## 🛠️ Troubleshooting

### "fazrepo: command not found"

1. **Restart your terminal** - PATH changes require a new shell session
2. **Check installation location**:
   ```bash
   # Linux/macOS
   ls -la ~/.local/bin/fazrepo
   
   # Windows
   dir %USERPROFILE%\.local\bin\fazrepo.exe
   ```
3. **Manually add to PATH**:
   ```bash
   # Linux/macOS (add to ~/.bashrc or ~/.zshrc)
   export PATH="$PATH:$HOME/.local/bin"
   
   # Windows PowerShell (run as administrator)
   $env:PATH += ";$env:USERPROFILE\.local\bin"
   ```

### Windows Installation Issues

1. **PowerShell Execution Policy**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Alternative using winget** (if available):
   ```cmd
   winget install fazrepo
   ```

3. **Use Windows Subsystem for Linux (WSL)**:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
   ```

## 🌍 Platform Support

fazrepo supports all major platforms and architectures:

| Platform | x86_64 | ARM64 | Notes |
|----------|--------|-------|-------|
| **Linux** | ✅ | ✅ | Ubuntu, Debian, CentOS, Fedora, Arch |
| **macOS** | ✅ | ✅ | Intel and Apple Silicon |
| **Windows** | ✅ | ✅ | Native, Git Bash, WSL, MSYS2 |

### Supported Installation Methods

| Method | Linux | macOS | Windows | Notes |
|--------|-------|-------|---------|-------|
| **Install Script** | ✅ | ✅ | ✅ | Recommended for all platforms |
| **Cargo** | ✅ | ✅ | ✅ | Requires Rust toolchain |
| **Homebrew** | ✅ | ✅ | ✅ | macOS/Linux package manager |
| **Direct Download** | ✅ | ✅ | ✅ | Manual installation |
| **Zip Archives** | ✅ | ✅ | ✅ | Portable installation |

## 📁 Monorepo Structure

This project uses [Turbo](https://turbo.build/) for efficient monorepo management.

```
faz-repo/
├── apps/
│   ├── cli/          # Rust CLI application
│   ├── web/          # Next.js landing page
│   └── docs/         # Nextra documentation site
├── packages/
│   ├── ui/           # Shared UI components
│   └── config/       # Shared configuration
└── scripts/          # Build and release scripts
```

## 🛠️ Development

### Prerequisites

- Node.js 18+ 
- Rust (for CLI development)
- pnpm (recommended) or npm

### Setup

```bash
# Install dependencies
pnpm install

# Build all packages
pnpm build

# Start development servers
pnpm dev
```

### Available Scripts

- `pnpm dev` - Start all development servers
- `pnpm build` - Build all packages
- `pnpm lint` - Lint all packages
- `pnpm test` - Run tests
- `pnpm clean` - Clean all build artifacts

### Individual Apps

```bash
# CLI development
pnpm cli:build
pnpm --filter cli dev

# Web development
pnpm web:dev
pnpm --filter web dev

# Docs development  
pnpm docs:dev
pnpm --filter docs dev
```

## 🌐 Web Applications

### Landing Page (`apps/web`)
- **Port**: 3000
- **Tech**: Next.js 14, TypeScript, Tailwind CSS
- **Purpose**: Marketing site and project showcase

### Documentation (`apps/docs`)
- **Port**: 3001  
- **Tech**: Nextra, MDX
- **Purpose**: Comprehensive documentation and guides

## 📦 Packages

### `@ui` - Shared UI Components
Reusable React components used across web applications:
- Button
- Card  
- Badge

### `@config` - Shared Configuration
Common configuration and constants shared across the monorepo.

## 🚀 CLI Features

- **Lightning Fast**: Built in Rust for maximum performance
- **Cross Platform**: Windows, macOS, and Linux support
- **Multiple Managers**: npm, yarn, pnpm, and bun
- **Colored Output**: Beautiful terminal output with status indicators
- **Detailed Mode**: Get installation paths and additional information

## 📋 Supported Package Managers

- **npm**: Node Package Manager
- **yarn**: Yarn Package Manager  
- **pnpm**: Performant npm
- **bun**: Bun Runtime & Package Manager

## 🎯 CLI Commands

### `fazrepo check`
Check versions of all installed package managers.

**Options:**
- `-d, --detailed`: Show detailed information including installation paths
- `-o, --only <managers>`: Only check specific package managers (comma-separated)

### `fazrepo list`
List all supported package managers with descriptions.

### `fazrepo version`
Show version information.

### `fazrepo init`
Initialize fazrepo in the current directory (creates a `.fazrepo` config file).

## 🏗️ Architecture

### Monorepo Benefits
- **Shared Dependencies**: Common packages reduce duplication
- **Atomic Changes**: Changes across multiple apps in single commit
- **Faster Builds**: Turbo's intelligent caching and parallel execution
- **Consistent Tooling**: Unified linting, testing, and build processes

### Technology Stack
- **CLI**: Rust with clap, tokio, colored
- **Web**: Next.js 14 with TypeScript and Tailwind CSS
- **Docs**: Nextra with MDX
- **Build System**: Turbo for monorepo management
- **Package Manager**: pnpm for efficient dependency management

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting: `pnpm test && pnpm lint`
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🔗 Links

- [Documentation](http://localhost:3001) (when running locally)
- [Landing Page](http://localhost:3000) (when running locally)
- [GitHub Repository](https://github.com/avadakedavra-wp/fazrepo)
- [Issues](https://github.com/avadakedavra-wp/fazrepo/issues)
