use crate::services::{ProjectService, OutputService};
use crate::models::ProjectConfig;
use anyhow::Result;

pub struct CreateCommand {
    project_service: Box<dyn ProjectService>,
    output_service: Box<dyn OutputService>,
}

impl CreateCommand {
    pub fn new(
        project_service: Box<dyn ProjectService>,
        output_service: Box<dyn OutputService>,
    ) -> Self {
        Self {
            project_service,
            output_service,
        }
    }

    pub async fn execute(&self, name: &str, template: Option<&str>) -> Result<()> {
        let template_name = template.unwrap_or("fullstack-nextjs");
        
        // Validate template exists
        if self.project_service.get_template(template_name).is_none() {
            self.output_service.display_error(&format!("Template '{}' not found", template_name));
            return Ok(());
        }

        let config = ProjectConfig::new(name, template_name);
        let result = self.project_service.create_project(&config)?;
        
        self.output_service.display_project_generation_result(&result);

        Ok(())
    }

    pub async fn list_templates(&self) -> Result<()> {
        let templates = self.project_service.list_templates();
        self.output_service.display_project_templates(&templates);
        Ok(())
    }
} 