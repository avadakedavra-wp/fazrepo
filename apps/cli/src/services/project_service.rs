use crate::models::{ProjectConfig, ProjectGenerationResult, ProjectTemplate};
use anyhow::Result;
use std::fs;
use std::path::Path;

pub trait ProjectService {
    fn create_project(&self, config: &ProjectConfig) -> Result<ProjectGenerationResult>;
    fn list_templates(&self) -> Vec<ProjectTemplate>;
    fn get_template(&self, name: &str) -> Option<ProjectTemplate>;
    fn validate_project_name(&self, name: &str) -> Result<()>;
}

#[derive(Clone)]
pub struct DefaultProjectService;

impl DefaultProjectService {
    pub fn new() -> Self {
        Self
    }

    fn get_default_templates(&self) -> Vec<ProjectTemplate> {
        vec![
            ProjectTemplate {
                name: "fullstack-nextjs".to_string(),
                description: "Full-stack Next.js application with TypeScript, Tailwind CSS, and Prisma".to_string(),
                category: crate::models::ProjectCategory::FullStack,
                technologies: vec![
                    "Next.js".to_string(),
                    "TypeScript".to_string(),
                    "Tailwind CSS".to_string(),
                    "Prisma".to_string(),
                    "PostgreSQL".to_string(),
                ],
                features: vec![
                    "Authentication".to_string(),
                    "Database integration".to_string(),
                    "API routes".to_string(),
                    "Responsive design".to_string(),
                ],
                dependencies: std::collections::HashMap::new(),
                structure: crate::models::ProjectStructure {
                    directories: vec![
                        "src".to_string(),
                        "src/app".to_string(),
                        "src/components".to_string(),
                        "src/lib".to_string(),
                        "src/types".to_string(),
                        "prisma".to_string(),
                        "public".to_string(),
                    ],
                    files: vec![
                        crate::models::ProjectFile {
                            path: "package.json".to_string(),
                            content: include_str!("../../templates/fullstack-nextjs/package.json").to_string(),
                            is_template: true,
                        },
                        crate::models::ProjectFile {
                            path: "next.config.js".to_string(),
                            content: include_str!("../../templates/fullstack-nextjs/next.config.js").to_string(),
                            is_template: true,
                        },
                        crate::models::ProjectFile {
                            path: "tailwind.config.js".to_string(),
                            content: include_str!("../../templates/fullstack-nextjs/tailwind.config.js").to_string(),
                            is_template: true,
                        },
                        crate::models::ProjectFile {
                            path: "tsconfig.json".to_string(),
                            content: include_str!("../../templates/fullstack-nextjs/tsconfig.json").to_string(),
                            is_template: true,
                        },
                        crate::models::ProjectFile {
                            path: "README.md".to_string(),
                            content: include_str!("../../templates/fullstack-nextjs/README.md").to_string(),
                            is_template: true,
                        },
                    ],
                },
                config_files: vec![],
            },
            ProjectTemplate {
                name: "api-express".to_string(),
                description: "Express.js API with TypeScript, validation, and testing setup".to_string(),
                category: crate::models::ProjectCategory::Backend,
                technologies: vec![
                    "Express.js".to_string(),
                    "TypeScript".to_string(),
                    "Jest".to_string(),
                    "Zod".to_string(),
                ],
                features: vec![
                    "REST API".to_string(),
                    "Input validation".to_string(),
                    "Error handling".to_string(),
                    "Testing setup".to_string(),
                ],
                dependencies: std::collections::HashMap::new(),
                structure: crate::models::ProjectStructure {
                    directories: vec![
                        "src".to_string(),
                        "src/routes".to_string(),
                        "src/middleware".to_string(),
                        "src/types".to_string(),
                        "tests".to_string(),
                    ],
                    files: vec![
                        crate::models::ProjectFile {
                            path: "package.json".to_string(),
                            content: include_str!("../../templates/api-express/package.json").to_string(),
                            is_template: true,
                        },
                        crate::models::ProjectFile {
                            path: "tsconfig.json".to_string(),
                            content: include_str!("../../templates/api-express/tsconfig.json").to_string(),
                            is_template: true,
                        },
                        crate::models::ProjectFile {
                            path: "README.md".to_string(),
                            content: include_str!("../../templates/api-express/README.md").to_string(),
                            is_template: true,
                        },
                    ],
                },
                config_files: vec![],
            },
        ]
    }

    fn process_template_content(&self, content: &str, config: &ProjectConfig) -> String {
        content
            .replace("{{PROJECT_NAME}}", &config.name)
            .replace("{{PROJECT_DESCRIPTION}}", &config.description)
            .replace("{{AUTHOR}}", &config.author)
            .replace("{{VERSION}}", &config.version)
            .replace("{{LICENSE}}", &config.license)
    }
}

impl ProjectService for DefaultProjectService {
    fn create_project(&self, config: &ProjectConfig) -> Result<ProjectGenerationResult> {
        let mut result = ProjectGenerationResult::failure(vec![]);

        // Validate project name
        if let Err(e) = self.validate_project_name(&config.name) {
            result.add_error(e.to_string());
            return Ok(result);
        }

        // Get template
        let template = match self.get_template(&config.template) {
            Some(t) => t,
            None => {
                result.add_error(format!("Template '{}' not found", config.template));
                return Ok(result);
            }
        };

        // Create project directory
        let project_path = Path::new(&config.name);
        if project_path.exists() {
            result.add_error(format!("Directory '{}' already exists", config.name));
            return Ok(result);
        }

        if let Err(e) = fs::create_dir_all(project_path) {
            result.add_error(format!("Failed to create project directory: {}", e));
            return Ok(result);
        }

        let mut files_created = Vec::new();

        // Create directories
        for dir in &template.structure.directories {
            let dir_path = project_path.join(dir);
            if let Err(e) = fs::create_dir_all(&dir_path) {
                result.add_error(format!("Failed to create directory '{}': {}", dir, e));
                continue;
            }
            files_created.push(format!("📁 {}", dir));
        }

        // Create files
        for file in &template.structure.files {
            let file_path = project_path.join(&file.path);
            
            // Ensure parent directory exists
            if let Some(parent) = file_path.parent() {
                if let Err(e) = fs::create_dir_all(parent) {
                    result.add_error(format!("Failed to create parent directory for '{}': {}", file.path, e));
                    continue;
                }
            }

            let content = if file.is_template {
                self.process_template_content(&file.content, config)
            } else {
                file.content.clone()
            };

            if let Err(e) = fs::write(&file_path, content) {
                result.add_error(format!("Failed to create file '{}': {}", file.path, e));
                continue;
            }

            files_created.push(format!("📄 {}", file.path));
        }

        // Create config files
        for config_file in &template.config_files {
            let file_path = project_path.join(&config_file.name);
            let content = self.process_template_content(&config_file.content, config);
            
            if let Err(e) = fs::write(&file_path, content) {
                result.add_error(format!("Failed to create config file '{}': {}", config_file.name, e));
                continue;
            }

            files_created.push(format!("⚙️ {}", config_file.name));
        }

        Ok(ProjectGenerationResult::success(
            config.name.clone(),
            files_created,
        ))
    }

    fn list_templates(&self) -> Vec<ProjectTemplate> {
        self.get_default_templates()
    }

    fn get_template(&self, name: &str) -> Option<ProjectTemplate> {
        self.get_default_templates()
            .into_iter()
            .find(|t| t.name == name)
    }

    fn validate_project_name(&self, name: &str) -> Result<()> {
        if name.is_empty() {
            return Err(anyhow::anyhow!("Project name cannot be empty"));
        }

        if name.contains(char::is_whitespace) {
            return Err(anyhow::anyhow!("Project name cannot contain spaces"));
        }

        if name.chars().any(|c| !c.is_alphanumeric() && c != '-' && c != '_') {
            return Err(anyhow::anyhow!("Project name can only contain alphanumeric characters, hyphens, and underscores"));
        }

        Ok(())
    }
} 