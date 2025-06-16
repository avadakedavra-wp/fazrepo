.PHONY: build install clean test release help

# Default target
help:
	@echo "Available targets:"
	@echo "  build      - Build the project in release mode"
	@echo "  install    - Install to /usr/local/bin (requires sudo)"
	@echo "  test       - Run tests"
	@echo "  clean      - Clean build artifacts"
	@echo "  release    - Build optimized release for multiple targets"
	@echo "  help       - Show this help message"

# Build release version
build:
	cargo build --release

# Install locally
install: build
	sudo cp target/release/fazrepo /usr/local/bin/

# Run tests
test:
	cargo test

# Clean build artifacts
clean:
	cargo clean

# Build for multiple targets (requires targets to be installed)
release:
	@echo "Building for multiple targets..."
	# Linux x86_64
	cargo build --release --target x86_64-unknown-linux-gnu
	# Linux aarch64
	cargo build --release --target aarch64-unknown-linux-gnu
	# macOS x86_64
	cargo build --release --target x86_64-apple-darwin
	# macOS aarch64
	cargo build --release --target aarch64-apple-darwin
	@echo "Release builds completed!"
	@echo "Binaries are in target/<target>/release/"

# Add targets for cross-compilation
add-targets:
	rustup target add x86_64-unknown-linux-gnu
	rustup target add aarch64-unknown-linux-gnu
	rustup target add x86_64-apple-darwin
	rustup target add aarch64-apple-darwin
