use serde::{Deserialize, Serialize};
use std::path::PathBuf;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackageManager {
    pub name: String,
    pub full_name: String,
    pub description: String,
    pub command: String,
    pub version: Option<String>,
    pub path: Option<PathBuf>,
    pub is_installed: bool,
    pub is_working: bool,
}

impl PackageManager {
    pub fn new(name: &str, full_name: &str, description: &str, command: &str) -> Self {
        Self {
            name: name.to_string(),
            full_name: full_name.to_string(),
            description: description.to_string(),
            command: command.to_string(),
            version: None,
            path: None,
            is_installed: false,
            is_working: false,
        }
    }

    pub fn with_version(mut self, version: String) -> Self {
        self.version = Some(version);
        self
    }

    pub fn with_path(mut self, path: PathBuf) -> Self {
        self.path = Some(path);
        self
    }

    pub fn mark_installed(mut self) -> Self {
        self.is_installed = true;
        self
    }

    pub fn mark_working(mut self) -> Self {
        self.is_working = true;
        self
    }

    pub fn get_display_name(&self) -> String {
        format!("{} ({})", self.full_name, self.name)
    }

    pub fn get_version_display(&self) -> String {
        self.version.clone().unwrap_or_else(|| "unknown".to_string())
    }

    pub fn get_path_display(&self) -> String {
        self.path
            .as_ref()
            .map(|p| p.display().to_string())
            .unwrap_or_else(|| "not found".to_string())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackageManagerCheckResult {
    pub package_manager: PackageManager,
    pub success: bool,
    pub error_message: Option<String>,
}

impl PackageManagerCheckResult {
    pub fn success(package_manager: PackageManager) -> Self {
        Self {
            package_manager,
            success: true,
            error_message: None,
        }
    }

    pub fn failure(package_manager: PackageManager, error_message: String) -> Self {
        Self {
            package_manager,
            success: false,
            error_message: Some(error_message),
        }
    }
} 