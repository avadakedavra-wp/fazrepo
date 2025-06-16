# Contributing to fazrepo

Thank you for your interest in contributing to fazrepo! This document provides guidelines for contributing to the project.

## Development Setup

### Prerequisites

- Rust 1.70+ (install via [rustup](https://rustup.rs/))
- Git

### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/avadakedavra-wp/fazrepo.git
   cd fazrepo
   ```

3. Build the project:
   ```bash
   cargo build
   ```

4. Run tests:
   ```bash
   cargo test
   ```

5. Run the CLI:
   ```bash
   cargo run -- --help
   ```

## Project Structure

```
fazrepo/
├── src/
│   └── master.rs              # Main CLI application
├── tests/
│   └── integration_tests.rs # Integration tests
├── .github/
│   └── workflows/           # GitHub Actions CI/CD
├── homebrew-fazrepo/
│   └── Formula/             # Homebrew formula
├── Cargo.toml               # Rust project configuration
├── README.md                # Project documentation
├── CHANGELOG.md             # Version history
├── LICENSE                  # MIT license
├── install.sh               # Universal installation script
├── release.sh               # Release automation script
└── Makefile                 # Build automation
```

## Development Commands

### Building
```bash
# Debug build
cargo build

# Release build
cargo build --release

# Using Makefile
make build
```

### Testing
```bash
# Run all tests
cargo test

# Run integration tests only
cargo test --test integration_tests

# Run with output
cargo test -- --nocapture
```

### Code Quality
```bash
# Format code
cargo fmt

# Check formatting
cargo fmt -- --check

# Lint with clippy
cargo clippy

# Check all
cargo check
```

### Running
```bash
# Run with cargo
cargo run -- check --detailed

# Run release binary
./target/release/fazrepo check

# Install locally
make install
```

## Adding New Package Managers

To add support for a new package manager:

1. Add the package manager to the list in `check_package_managers()` function
2. Ensure the package manager supports `--version` flag
3. Add it to the documentation in `list_package_managers()` function
4. Update tests and documentation
5. Test on multiple platforms

## Release Process

1. Update version in `Cargo.toml`
2. Update `CHANGELOG.md`
3. Run tests: `cargo test`
4. Use the release script: `./release.sh <version>`
5. Push changes and tag: `git push origin master && git push origin v<version>`
6. GitHub Actions will automatically build and create releases

## Code Style

- Follow Rust standard formatting (enforced by `cargo fmt`)
- Use descriptive variable and function names
- Add documentation for public functions
- Keep functions focused and small
- Use appropriate error handling with `anyhow`

## Testing Guidelines

- Write tests for new functionality
- Ensure integration tests cover CLI behavior
- Test error conditions
- Verify cross-platform compatibility

## Submitting Changes

1. Create a feature branch: `git checkout -b feature/amazing-feature`
2. Make your changes
3. Add tests for new functionality
4. Ensure all tests pass: `cargo test`
5. Format code: `cargo fmt`
6. Commit changes: `git commit -m 'Add amazing feature'`
7. Push to your fork: `git push origin feature/amazing-feature`
8. Submit a Pull Request

## Pull Request Guidelines

- Provide a clear description of changes
- Reference any related issues
- Ensure CI passes
- Update documentation if needed
- Add tests for new features

## Issues and Bugs

When reporting issues, please include:

- Operating system and version
- Rust version (`rustc --version`)
- fazrepo version (`fazrepo --version`)
- Steps to reproduce
- Expected vs actual behavior
- Error messages (if any)

## Questions?

Feel free to open an issue for questions about contributing or development!
