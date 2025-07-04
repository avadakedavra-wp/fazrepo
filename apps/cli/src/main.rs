mod commands;
mod models;
mod services;
mod utils;

use anyhow::Result;
use clap::{Parser, Subcommand};
use commands::*;
use services::*;
use utils::constants::*;

const VERSION: &str = env!("CARGO_PKG_VERSION");

#[derive(Parser)]
#[command(name = APP_NAME)]
#[command(about = APP_DESCRIPTION)]
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
    /// Create a new project from template
    Create {
        /// Project name
        name: String,
        /// Template to use
        #[arg(short, long)]
        template: Option<String>,
    },
    /// List available project templates
    Templates,
    /// Show version information
    Version,
    /// Initialize fazrepo in current directory
    Init,
    /// List all supported package managers
    List,
}

struct App {
    check_command: CheckCommand,
    create_command: CreateCommand,
    init_command: InitCommand,
    list_command: ListCommand,
    version_command: VersionCommand,
}

impl App {
    fn new() -> Self {
        // Initialize services with dependency injection
        let package_manager_service = Box::new(DefaultPackageManagerService::new());
        let project_service = Box::new(DefaultProjectService::new());
        let config_service = Box::new(DefaultConfigService::new());
        let output_service = Box::new(ColoredOutputService::new());

        // Initialize commands with their dependencies
        let check_command = CheckCommand::new(
            package_manager_service.clone(),
            output_service.clone(),
        );
        let create_command = CreateCommand::new(
            project_service.clone(),
            output_service.clone(),
        );
        let init_command = InitCommand::new(
            config_service.clone(),
            output_service.clone(),
        );
        let list_command = ListCommand::new(
            package_manager_service.clone(),
            output_service.clone(),
        );
        let version_command = VersionCommand::new(output_service.clone());

        Self {
            check_command,
            create_command,
            init_command,
            list_command,
            version_command,
        }
    }

    async fn run(&self, cli: Cli) -> Result<()> {
        match &cli.command {
            Some(Commands::Check { detailed, only }) => {
                self.check_command.execute(*detailed, only.as_deref()).await?
            }
            Some(Commands::Create { name, template }) => {
                self.create_command.execute(name, template.as_deref()).await?
            }
            Some(Commands::Templates) => {
                self.create_command.list_templates().await?
            }
            Some(Commands::Version) => {
                self.version_command.execute().await?
            }
            Some(Commands::Init) => {
                self.init_command.execute().await?
            }
            Some(Commands::List) => {
                self.list_command.execute().await?
            }
            None => {
                // Default behavior - check package managers
                self.check_command.execute(false, None).await?;
            }
        }

        Ok(())
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let cli = Cli::parse();
    let app = App::new();
    app.run(cli).await
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_version_constant() {
        assert!(!VERSION.is_empty());
    }

    #[test]
    fn test_app_name_constant() {
        assert_eq!(APP_NAME, "fazrepo");
    }
}
