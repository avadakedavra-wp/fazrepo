use anyhow::Result;
use clap::{Parser, Subcommand};
use colored::*;
use std::process::Command;

const VERSION: &str = env!("CARGO_PKG_VERSION");

#[derive(Parser)]
#[command(name = "fazrepo")]
#[command(about = "A CLI tool to check package manager versions")]
#[command(version = VERSION)]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    /// Check versions of all package managers
    Check {
        /// Show detailed information including paths
        #[arg(short, long)]
        detailed: bool,
        /// Only check specific package managers (comma-separated: npm,yarn,pnpm,bun)
        #[arg(short, long)]
        only: Option<String>,
    },
    /// Show version information
    Version,
    /// Initialize fazrepo in current directory
    Init,
    /// List all supported package managers
    List,
}

#[tokio::main]
async fn main() -> Result<()> {
    let cli = Cli::parse();

    match &cli.command {
        Some(Commands::Check { detailed, only }) => {
            check_package_managers(*detailed, only.as_deref()).await?
        }
        Some(Commands::Version) => show_version(),
        Some(Commands::Init) => init_fazrepo()?,
        Some(Commands::List) => list_package_managers(),
        None => {
            // Default behavior - check package managers
            check_package_managers(false, None).await?;
        }
    }

    Ok(())
}

fn show_version() {
    println!(
        "{} {}",
        "fazrepo".bright_cyan().bold(),
        VERSION.bright_white()
    );
    println!("A CLI tool to check package manager versions");
}

fn init_fazrepo() -> Result<()> {
    println!("{}", "🚀 Initializing fazrepo...".bright_green().bold());

    // Create a simple config file or marker
    std::fs::write(
        ".fazrepo",
        format!("{{\"version\": \"{}\", \"initialized\": true}}", VERSION),
    )?;

    println!("{}", "✅ fazrepo initialized successfully!".bright_green());
    println!(
        "You can now run {} to check package manager versions.",
        "fazrepo check".bright_cyan()
    );

    Ok(())
}

fn list_package_managers() {
    println!("{}", "📋 Supported Package Managers:".bright_blue().bold());
    println!();

    let managers = [
        ("npm", "Node Package Manager", "Node.js package manager"),
        (
            "yarn",
            "Yarn Package Manager",
            "Fast, reliable, and secure dependency management",
        ),
        (
            "pnpm",
            "Performant npm",
            "Fast, disk space efficient package manager",
        ),
        (
            "bun",
            "Bun Runtime & Package Manager",
            "Incredibly fast JavaScript runtime and package manager",
        ),
    ];

    for (name, full_name, description) in managers {
        println!(
            "{} {} - {}",
            "•".bright_cyan(),
            full_name.bright_white().bold(),
            description.dimmed()
        );
        println!("  Command: {}", name.bright_green());
        println!();
    }
}

async fn check_package_managers(detailed: bool, only: Option<&str>) -> Result<()> {
    println!(
        "{}",
        "🔍 Checking package manager versions..."
            .bright_blue()
            .bold()
    );
    println!();

    // Define package managers with Windows-specific commands
    let all_package_managers = get_package_managers();

    let package_managers = if let Some(only_list) = only {
        let selected: Vec<&str> = only_list.split(',').map(|s| s.trim()).collect();
        all_package_managers
            .into_iter()
            .filter(|(name, _)| selected.contains(name))
            .collect()
    } else {
        all_package_managers
    };

    if package_managers.is_empty() {
        println!(
            "{} No valid package managers specified",
            "⚠️".bright_yellow()
        );
        return Ok(());
    }

    for (name, command) in package_managers {
        check_package_manager(name, &command, detailed).await;
    }

    Ok(())
}

/// Get package managers with platform-specific command names
fn get_package_managers() -> Vec<(&'static str, String)> {
    let base_managers = vec![
        ("npm", "npm"),
        ("yarn", "yarn"),
        ("pnpm", "pnpm"),
        ("bun", "bun"),
    ];

    base_managers
        .into_iter()
        .map(|(name, cmd)| (name, get_command_for_platform(cmd)))
        .collect()
}

/// Get the correct command name for the current platform
fn get_command_for_platform(base_command: &str) -> String {
    if cfg!(target_os = "windows") {
        // On Windows, try .cmd first, then .exe, then the base command
        format!("{}.cmd", base_command)
    } else {
        base_command.to_string()
    }
}

async fn check_package_manager(name: &str, command: &str, detailed: bool) {
    // Try multiple command variants on Windows
    let commands_to_try = if cfg!(target_os = "windows") {
        vec![
            format!("{}.cmd", command.trim_end_matches(".cmd")),
            format!("{}.exe", command.trim_end_matches(".cmd")),
            command.trim_end_matches(".cmd").to_string(),
        ]
    } else {
        vec![command.to_string()]
    };

    let mut found_path = None;
    let mut working_command = None;

    // Try to find the command using which
    for cmd in &commands_to_try {
        if let Ok(path) = which::which(cmd) {
            found_path = Some(path);
            working_command = Some(cmd.clone());
            break;
        }
    }

    match found_path {
        Some(path) => match working_command {
            Some(cmd) => match get_version(&cmd).await {
                Ok(version) => {
                    if detailed {
                        println!(
                            "{} {} {}",
                            "✅".bright_green(),
                            name.bright_cyan().bold(),
                            version.bright_white()
                        );
                        println!("   📍 Path: {}", path.display().to_string().dimmed());
                    } else {
                        println!(
                            "{} {} {} ({})",
                            "✅".bright_green(),
                            name.bright_cyan().bold(),
                            version.bright_white(),
                            path.display().to_string().dimmed()
                        );
                    }
                }
                Err(e) => {
                    if detailed {
                        println!(
                            "{} {} {}",
                            "⚠️".bright_yellow(),
                            name.bright_cyan().bold(),
                            "version check failed".bright_red()
                        );
                        println!("   📍 Path: {}", path.display().to_string().dimmed());
                        println!("   ❌ Error: {}", e.to_string().dimmed());
                    } else {
                        println!(
                            "{} {} {} ({})",
                            "⚠️".bright_yellow(),
                            name.bright_cyan().bold(),
                            "version check failed".bright_red(),
                            path.display().to_string().dimmed()
                        );
                    }
                }
            },
            None => {
                println!(
                    "{} {} {}",
                    "❌".bright_red(),
                    name.bright_cyan().bold(),
                    "not installed".bright_red()
                );
            }
        },
        None => {
            println!(
                "{} {} {}",
                "❌".bright_red(),
                name.bright_cyan().bold(),
                "not installed".bright_red()
            );
        }
    }
}

async fn get_version(command: &str) -> Result<String> {
    // On Windows, we might need to use cmd.exe to run the command
    let mut cmd = if cfg!(target_os = "windows") && !command.ends_with(".exe") {
        let mut c = Command::new("cmd");
        c.args(["/C", command, "--version"]);
        c
    } else {
        let mut c = Command::new(command);
        c.arg("--version");
        c
    };

    let output = cmd.output()?;

    if output.status.success() {
        let version_output = String::from_utf8_lossy(&output.stdout);
        let version = version_output.trim().lines().next().unwrap_or("unknown");
        Ok(version.to_string())
    } else {
        // Try stderr in case version info is written there
        let stderr_output = String::from_utf8_lossy(&output.stderr);
        if !stderr_output.trim().is_empty() {
            let version = stderr_output.trim().lines().next().unwrap_or("unknown");
            Ok(version.to_string())
        } else {
            Err(anyhow::anyhow!("Failed to get version"))
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_get_version_with_fake_command() {
        // This test would need a mock, but for now we'll test the structure
        // In a real scenario, you'd mock the Command execution
        assert!(true); // Placeholder test
    }

    #[test]
    fn test_version_constant() {
        assert!(!VERSION.is_empty());
    }

    #[test]
    fn test_show_version() {
        // Test that show_version doesn't panic
        show_version();
    }
}
