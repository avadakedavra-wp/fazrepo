use crate::models::{PackageManagerCheckResult, ProjectGenerationResult, ProjectTemplate};
use colored::*;

pub trait OutputService {
    fn display_package_manager_results(&self, results: &[PackageManagerCheckResult], detailed: bool);
    fn display_project_templates(&self, templates: &[ProjectTemplate]);
    fn display_project_generation_result(&self, result: &ProjectGenerationResult);
    fn display_version(&self);
    fn display_init_success(&self);
    fn display_error(&self, message: &str);
    fn display_success(&self, message: &str);
    fn display_info(&self, message: &str);
}

#[derive(Clone)]
pub struct ColoredOutputService;

impl ColoredOutputService {
    pub fn new() -> Self {
        Self
    }
}

impl OutputService for ColoredOutputService {
    fn display_package_manager_results(&self, results: &[PackageManagerCheckResult], detailed: bool) {
        println!(
            "{}",
            "🔍 Checking package manager versions..."
                .bright_blue()
                .bold()
        );
        println!();

        for result in results {
            let pm = &result.package_manager;
            
            if result.success {
                if detailed {
                    println!(
                        "{} {} {}",
                        "✅".bright_green(),
                        pm.name.bright_cyan().bold(),
                        pm.get_version_display().bright_white()
                    );
                    println!("   📍 Path: {}", pm.get_path_display().dimmed());
                } else {
                    println!(
                        "{} {} {} ({})",
                        "✅".bright_green(),
                        pm.name.bright_cyan().bold(),
                        pm.get_version_display().bright_white(),
                        pm.get_path_display().dimmed()
                    );
                }
            } else {
                if detailed {
                    println!(
                        "{} {} {}",
                        "⚠️".bright_yellow(),
                        pm.name.bright_cyan().bold(),
                        "version check failed".bright_red()
                    );
                    if let Some(path) = &pm.path {
                        println!("   📍 Path: {}", path.display().to_string().dimmed());
                    }
                    if let Some(error) = &result.error_message {
                        println!("   ❌ Error: {}", error.dimmed());
                    }
                } else {
                    println!(
                        "{} {} {}",
                        "❌".bright_red(),
                        pm.name.bright_cyan().bold(),
                        "not installed".bright_red()
                    );
                }
            }
        }
    }

    fn display_project_templates(&self, templates: &[ProjectTemplate]) {
        println!("{}", "📋 Available Project Templates:".bright_blue().bold());
        println!();

        for template in templates {
            println!(
                "{} {} - {}",
                "•".bright_cyan(),
                template.name.bright_white().bold(),
                template.description.dimmed()
            );
            
            println!("  Category: {}", format!("{:?}", template.category).bright_green());
            println!("  Technologies: {}", template.technologies.join(", ").bright_yellow());
            println!("  Features: {}", template.features.join(", ").dimmed());
            println!();
        }
    }

    fn display_project_generation_result(&self, result: &ProjectGenerationResult) {
        if result.success {
            println!("{}", "🎉 Project created successfully!".bright_green().bold());
            
            if let Some(path) = &result.project_path {
                println!("📁 Project location: {}", path.bright_cyan());
            }
            
            println!("📄 Files created:");
            for file in &result.files_created {
                println!("  {}", file);
            }
            
            if !result.warnings.is_empty() {
                println!("\n⚠️ Warnings:");
                for warning in &result.warnings {
                    println!("  {}", warning.bright_yellow());
                }
            }
        } else {
            println!("{}", "❌ Project creation failed!".bright_red().bold());
            println!("Errors:");
            for error in &result.errors {
                println!("  {}", error.bright_red());
            }
        }
    }

    fn display_version(&self) {
        println!(
            "{} {}",
            "fazrepo".bright_cyan().bold(),
            env!("CARGO_PKG_VERSION").bright_white()
        );
        println!("A CLI tool for full-stack project generation and package manager checking");
    }

    fn display_init_success(&self) {
        println!("{}", "🚀 FazRepo initialized successfully!".bright_green().bold());
        println!(
            "You can now run {} to check package manager versions or {} to create projects.",
            "fazrepo check".bright_cyan(),
            "fazrepo create".bright_cyan()
        );
    }

    fn display_error(&self, message: &str) {
        println!("{} {}", "❌ Error:".bright_red().bold(), message.bright_red());
    }

    fn display_success(&self, message: &str) {
        println!("{} {}", "✅ Success:".bright_green().bold(), message.bright_green());
    }

    fn display_info(&self, message: &str) {
        println!("{} {}", "ℹ️ Info:".bright_blue().bold(), message.bright_blue());
    }
} 