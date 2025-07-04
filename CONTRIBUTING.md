# Contributing to FazRepo

Thank you for your interest in contributing to FazRepo! This document provides guidelines and information for contributors.

## 🏗️ Project Architecture

FazRepo follows **SOLID principles** and **Clean Architecture** patterns:

### **SOLID Principles**
- **Single Responsibility**: Each class/module has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Derived classes can substitute base classes
- **Interface Segregation**: Clients depend only on interfaces they use
- **Dependency Inversion**: High-level modules don't depend on low-level modules

### **Project Structure**
```
apps/cli/src/
├── commands/          # Command handlers (Command Pattern)
├── services/          # Business logic (Service Layer)
├── models/           # Data structures and entities
├── utils/            # Utility functions and constants
├── config/           # Configuration management
└── main.rs           # Application entry point
```

## 🚀 Getting Started

### Prerequisites
- Rust 1.70+
- Node.js 18+ (for monorepo)
- pnpm (recommended)

### Setup
1. **Clone the repository**:
   ```bash
   git clone https://github.com/avadakedavra-wp/fazrepo.git
   cd fazrepo
   ```

2. **Run the setup script**:
   ```bash
   ./scripts/setup-dev.sh
   ```

3. **Build the CLI**:
   ```bash
   pnpm cli:build
   ```

## 🧪 Development Workflow

### 1. **Create a Feature Branch**
```bash
git checkout -b feature/your-feature-name
```

### 2. **Follow Code Style**
- Use `cargo fmt` for formatting
- Use `cargo clippy` for linting
- Follow Rust naming conventions
- Add comprehensive comments

### 3. **Write Tests**
- Unit tests for services
- Integration tests for commands
- Test coverage should be >80%

### 4. **Update Documentation**
- Update README.md if needed
- Add inline documentation
- Update command help text

### 5. **Commit Guidelines**
Use conventional commits:
```
feat: add new project template
fix: resolve package manager detection issue
docs: update installation instructions
test: add tests for project service
refactor: improve error handling
```

## 📁 Code Organization

### **Commands Layer** (`commands/`)
- Implements the Command Pattern
- Each command is a separate struct
- Commands depend on services via dependency injection
- Handle user input and coordinate services

### **Services Layer** (`services/`)
- Contains business logic
- Implements service traits for testability
- No direct dependencies on external frameworks
- Single responsibility for each service

### **Models Layer** (`models/`)
- Data structures and entities
- Serialization/deserialization logic
- Validation rules
- Domain-specific logic

### **Utils Layer** (`utils/`)
- Helper functions
- Constants
- Platform-specific utilities
- Pure functions only

## 🔧 Adding New Features

### **Adding a New Command**
1. Create command struct in `commands/`
2. Implement command logic
3. Add to CLI parser in `main.rs`
4. Add tests
5. Update documentation

### **Adding a New Service**
1. Define service trait
2. Implement concrete service
3. Add to dependency injection
4. Write unit tests
5. Update service registry

### **Adding a New Project Template**
1. Create template directory in `templates/`
2. Add template files with placeholders
3. Update `ProjectService` to include template
4. Add template metadata
5. Test template generation

## 🧪 Testing

### **Running Tests**
```bash
# All tests
cargo test

# Specific test
cargo test test_name

# With output
cargo test -- --nocapture
```

### **Test Structure**
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_feature_name() {
        // Arrange
        // Act
        // Assert
    }
}
```

### **Mocking Services**
Use trait objects for dependency injection:
```rust
pub trait MyService {
    fn do_something(&self) -> Result<String>;
}

// In tests
struct MockMyService;
impl MyService for MockMyService {
    fn do_something(&self) -> Result<String> {
        Ok("mocked result".to_string())
    }
}
```

## 📝 Code Review Guidelines

### **What to Look For**
- SOLID principles adherence
- Error handling
- Test coverage
- Documentation
- Performance considerations
- Security implications

### **Review Process**
1. **Self-review** your changes
2. **Run tests** locally
3. **Create pull request** with clear description
4. **Address feedback** from reviewers
5. **Merge** after approval

## 🐛 Bug Reports

### **Before Reporting**
1. Check existing issues
2. Try latest version
3. Reproduce the issue
4. Gather system information

### **Bug Report Template**
```markdown
**Description**
Clear description of the issue

**Steps to Reproduce**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: [e.g., Ubuntu 22.04]
- Rust version: [e.g., 1.70.0]
- FazRepo version: [e.g., 0.2.0]

**Additional Context**
Any other relevant information
```

## 💡 Feature Requests

### **Before Requesting**
1. Check if feature already exists
2. Consider if it fits project scope
3. Think about implementation approach

### **Feature Request Template**
```markdown
**Problem**
Clear description of the problem

**Proposed Solution**
Description of the proposed solution

**Alternatives Considered**
Other approaches you considered

**Additional Context**
Any other relevant information
```

## 🏷️ Release Process

### **Versioning**
Follow semantic versioning:
- **Major**: Breaking changes
- **Minor**: New features (backward compatible)
- **Patch**: Bug fixes (backward compatible)

### **Release Steps**
1. Update version in `Cargo.toml`
2. Update CHANGELOG.md
3. Create release tag
4. Build and test
5. Create GitHub release
6. Update documentation

## 🤝 Community Guidelines

### **Code of Conduct**
- Be respectful and inclusive
- Help others learn
- Provide constructive feedback
- Follow project conventions

### **Communication**
- Use GitHub Issues for bugs
- Use GitHub Discussions for questions
- Be clear and concise
- Provide context and examples

## 📚 Resources

### **Rust Resources**
- [Rust Book](https://doc.rust-lang.org/book/)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- [Rust Testing](https://doc.rust-lang.org/book/ch11-00-testing.html)

### **Architecture Resources**
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Command Pattern](https://en.wikipedia.org/wiki/Command_pattern)

## 🎯 Getting Help

- **Issues**: [GitHub Issues](https://github.com/avadakedavra-wp/fazrepo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/avadakedavra-wp/fazrepo/discussions)
- **Documentation**: [README.md](README.md)

Thank you for contributing to FazRepo! 🚀
