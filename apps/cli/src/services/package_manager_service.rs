use crate::models::{PackageManager, PackageManagerCheckResult};
use anyhow::Result;
use std::process::Command;
use which;

#[async_trait::async_trait]
pub trait PackageManagerService {
    fn get_supported_managers(&self) -> Vec<PackageManager>;
    async fn check_manager(&self, manager: &PackageManager) -> Result<PackageManagerCheckResult>;
    async fn check_managers(&self, managers: Vec<PackageManager>) -> Vec<PackageManagerCheckResult>;
}

#[derive(Clone)]
pub struct DefaultPackageManagerService;

impl DefaultPackageManagerService {
    pub fn new() -> Self {
        Self
    }

    fn get_platform_command(&self, base_command: &str) -> String {
        if cfg!(target_os = "windows") {
            format!("{}.cmd", base_command)
        } else {
            base_command.to_string()
        }
    }

    fn get_commands_to_try(&self, command: &str) -> Vec<String> {
        if cfg!(target_os = "windows") {
            vec![
                format!("{}.cmd", command.trim_end_matches(".cmd")),
                format!("{}.exe", command.trim_end_matches(".cmd")),
                command.trim_end_matches(".cmd").to_string(),
            ]
        } else {
            vec![command.to_string()]
        }
    }

    async fn get_version(&self, command: &str) -> Result<String> {
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
            let stderr_output = String::from_utf8_lossy(&output.stderr);
            if !stderr_output.trim().is_empty() {
                let version = stderr_output.trim().lines().next().unwrap_or("unknown");
                Ok(version.to_string())
            } else {
                Err(anyhow::anyhow!("Failed to get version"))
            }
        }
    }
}

#[async_trait::async_trait]
impl PackageManagerService for DefaultPackageManagerService {
    fn get_supported_managers(&self) -> Vec<PackageManager> {
        vec![
            PackageManager::new("npm", "Node Package Manager", "Node.js package manager", "npm"),
            PackageManager::new("yarn", "Yarn Package Manager", "Fast, reliable, and secure dependency management", "yarn"),
            PackageManager::new("pnpm", "Performant npm", "Fast, disk space efficient package manager", "pnpm"),
            PackageManager::new("bun", "Bun Runtime & Package Manager", "Incredibly fast JavaScript runtime and package manager", "bun"),
        ]
        .into_iter()
        .map(|pm| {
            let command = self.get_platform_command(&pm.command);
            PackageManager {
                command,
                ..pm
            }
        })
        .collect()
    }

    async fn check_manager(&self, manager: &PackageManager) -> Result<PackageManagerCheckResult> {
        let commands_to_try = self.get_commands_to_try(&manager.command);
        
        for cmd in &commands_to_try {
            if let Ok(path) = which::which(cmd) {
                match self.get_version(cmd).await {
                    Ok(version) => {
                        let mut updated_manager = manager.clone();
                        updated_manager = updated_manager
                            .with_version(version)
                            .with_path(path)
                            .mark_installed()
                            .mark_working();
                        return Ok(PackageManagerCheckResult::success(updated_manager));
                    }
                    Err(e) => {
                        let mut updated_manager = manager.clone();
                        updated_manager = updated_manager
                            .with_path(path)
                            .mark_installed();
                        return Ok(PackageManagerCheckResult::failure(
                            updated_manager,
                            e.to_string(),
                        ));
                    }
                }
            }
        }

        Ok(PackageManagerCheckResult::failure(
            manager.clone(),
            "Command not found".to_string(),
        ))
    }

    async fn check_managers(&self, managers: Vec<PackageManager>) -> Vec<PackageManagerCheckResult> {
        let mut results = Vec::new();
        
        for manager in managers {
            match self.check_manager(&manager).await {
                Ok(result) => results.push(result),
                Err(e) => results.push(PackageManagerCheckResult::failure(
                    manager,
                    e.to_string(),
                )),
            }
        }
        
        results
    }
} 