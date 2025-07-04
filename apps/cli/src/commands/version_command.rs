use crate::services::OutputService;
use anyhow::Result;

pub struct VersionCommand {
    output_service: Box<dyn OutputService>,
}

impl VersionCommand {
    pub fn new(output_service: Box<dyn OutputService>) -> Self {
        Self { output_service }
    }

    pub async fn execute(&self) -> Result<()> {
        self.output_service.display_version();
        Ok(())
    }
} 