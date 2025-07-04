use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::path::PathBuf;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppConfig {
    pub version: String,
    pub initialized: bool,
    pub settings: AppSettings,
    pub templates: HashMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppSettings {
    pub output_format: OutputFormat,
    pub color_output: bool,
    pub detailed_output: bool,
    pub default_template: String,
    pub project_directory: Option<PathBuf>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum OutputFormat {
    Text,
    Json,
    Yaml,
}

impl Default for AppConfig {
    fn default() -> Self {
        Self {
            version: env!("CARGO_PKG_VERSION").to_string(),
            initialized: false,
            settings: AppSettings::default(),
            templates: HashMap::new(),
        }
    }
}

impl Default for AppSettings {
    fn default() -> Self {
        Self {
            output_format: OutputFormat::Text,
            color_output: true,
            detailed_output: false,
            default_template: "fullstack-nextjs".to_string(),
            project_directory: None,
        }
    }
}

impl AppConfig {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn with_template(mut self, name: &str, path: &str) -> Self {
        self.templates.insert(name.to_string(), path.to_string());
        self
    }

    pub fn set_project_directory(mut self, path: PathBuf) -> Self {
        self.settings.project_directory = Some(path);
        self
    }

    pub fn get_template_path(&self, name: &str) -> Option<&String> {
        self.templates.get(name)
    }
} 