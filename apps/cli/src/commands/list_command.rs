use crate::services::{PackageManagerService, OutputService};
use anyhow::Result;
use colored::Colorize;

pub struct ListCommand {
    package_manager_service: Box<dyn PackageManagerService>,
    output_service: Box<dyn OutputService>,
}

impl ListCommand {
    pub fn new(
        package_manager_service: Box<dyn PackageManagerService>,
        output_service: Box<dyn OutputService>,
    ) -> Self {
        Self {
            package_manager_service,
            output_service,
        }
    }

    pub async fn execute(&self) -> Result<()> {
        let managers = self.package_manager_service.get_supported_managers();
        
        println!("{}", "📋 Supported Package Managers:".bright_blue().bold());
        println!();

        for manager in managers {
            println!(
                "{} {} - {}",
                "•".bright_cyan(),
                manager.get_display_name().bright_white().bold(),
                manager.description.dimmed()
            );
            println!("  Command: {}", manager.command.bright_green());
            println!();
        }

        Ok(())
    }
} 