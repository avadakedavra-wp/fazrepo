# fazrepo

A fast CLI tool to check package manager versions on your system.

## Features

- 🚀 Check versions of npm, yarn, pnpm, and bun
- 🎨 Beautiful colored output
- ⚡ Fast and lightweight
- 🔧 Easy installation via Homebrew or curl

## Installation

### Homebrew (macOS/Linux)

```bash
brew tap avadakedavra-wp/fazrepo
brew install fazrepo
```

### Curl (Universal)

```bash
curl -fsSL https://raw.githubusercontent.com/avadakedavra-wp/fazrepo/main/install.sh | bash
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

## Sample Output

```
🔍 Checking package manager versions...

✅ npm 10.9.0 (/usr/local/bin/npm)
❌ yarn not installed
✅ pnpm 9.13.2 (/usr/local/bin/pnpm)
✅ bun 1.1.38 (/home/user/.bun/bin/bun)
```

## Package Managers Supported

- **npm** - Node Package Manager
- **yarn** - Yet Another Resource Negotiator
- **pnpm** - Performant npm
- **bun** - Bun JavaScript runtime and package manager

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
