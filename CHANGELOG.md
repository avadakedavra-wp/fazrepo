# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2025-01-14

### Added
- Complete Windows support with smart package manager detection
- Cross-platform builds for Linux, macOS, Windows (x86_64, ARM64)
- Windows-specific installation script (install.ps1)
- Enhanced command resolution for .cmd and .exe variants on Windows
- Comprehensive Windows documentation and development guides
- GitHub Actions CI/CD for automated cross-platform releases

### Fixed
- Binary path in Cargo.toml (master.rs → main.rs)
- Tokio main function decorator (#[tokio::master] → #[tokio::main])
- Windows-specific PATH handling and command execution
- Error handling to check both stdout and stderr for version information

### Improved
- Enhanced testing framework with cross-platform compatibility tests
- Updated installation scripts with Windows environment detection
- Better error messages and debugging information
- Comprehensive project documentation and setup guides

## [0.1.0] - 2025-06-17

### Added
- Initial release of fazrepo CLI tool
- Check versions of npm, yarn, pnpm, and bun package managers
- Colorized output with emojis for better user experience
- Support for installation via Homebrew and curl
- Cross-platform support (Linux, macOS)
- `fazrepo check` command to check all package managers
- `fazrepo init` command to initialize fazrepo in current directory
- `fazrepo version` command to show version information
- Comprehensive error handling and user-friendly messages
- GitHub Actions CI/CD pipeline for automated testing and releases
- Integration tests and unit tests
- Professional project structure with proper documentation

### Features
- 🚀 Fast and lightweight CLI tool written in Rust
- 🎨 Beautiful colored output with status indicators
- ⚡ Asynchronous operation for better performance
- 🔧 Easy installation methods (Homebrew, curl, from source)
- 📦 Support for all major JavaScript package managers
- 🧪 Comprehensive test coverage
- 📋 Professional documentation and examples

[Unreleased]: https://github.com/avadakedavra-wp/fazrepo/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/avadakedavra-wp/fazrepo/releases/tag/v0.1.0
