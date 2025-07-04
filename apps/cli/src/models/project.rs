use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectTemplate {
    pub name: String,
    pub description: String,
    pub category: ProjectCategory,
    pub technologies: Vec<String>,
    pub features: Vec<String>,
    pub dependencies: HashMap<String, Vec<String>>,
    pub structure: ProjectStructure,
    pub config_files: Vec<ConfigFile>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ProjectCategory {
    FullStack,
    Frontend,
    Backend,
    Mobile,
    Desktop,
    Library,
    Tool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectStructure {
    pub directories: Vec<String>,
    pub files: Vec<ProjectFile>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectFile {
    pub path: String,
    pub content: String,
    pub is_template: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConfigFile {
    pub name: String,
    pub content: String,
    pub description: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectConfig {
    pub name: String,
    pub description: String,
    pub author: String,
    pub version: String,
    pub license: String,
    pub template: String,
    pub customizations: HashMap<String, String>,
}

impl ProjectConfig {
    pub fn new(name: &str, template: &str) -> Self {
        Self {
            name: name.to_string(),
            description: "A new project".to_string(),
            author: "Developer".to_string(),
            version: "0.1.0".to_string(),
            license: "MIT".to_string(),
            template: template.to_string(),
            customizations: HashMap::new(),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectGenerationResult {
    pub success: bool,
    pub project_path: Option<String>,
    pub files_created: Vec<String>,
    pub errors: Vec<String>,
    pub warnings: Vec<String>,
}

impl ProjectGenerationResult {
    pub fn success(project_path: String, files_created: Vec<String>) -> Self {
        Self {
            success: true,
            project_path: Some(project_path),
            files_created,
            errors: Vec::new(),
            warnings: Vec::new(),
        }
    }

    pub fn failure(errors: Vec<String>) -> Self {
        Self {
            success: false,
            project_path: None,
            files_created: Vec::new(),
            errors,
            warnings: Vec::new(),
        }
    }

    pub fn add_warning(&mut self, warning: String) {
        self.warnings.push(warning);
    }

    pub fn add_error(&mut self, error: String) {
        self.errors.push(error);
    }
} 