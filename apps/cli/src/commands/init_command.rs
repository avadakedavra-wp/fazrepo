use crate::services::{ConfigService, OutputService};
use anyhow::Result;

pub struct InitCommand {
    config_service: Box<dyn ConfigService>,
    output_service: Box<dyn OutputService>,
}

impl InitCommand {
    pub fn new(
        config_service: Box<dyn ConfigService>,
        output_service: Box<dyn OutputService>,
    ) -> Self {
        Self {
            config_service,
            output_service,
        }
    }

    pub async fn execute(&self) -> Result<()> {
        match self.config_service.init_config() {
            Ok(_) => {
                self.output_service.display_init_success();
                Ok(())
            }
            Err(e) => {
                self.output_service.display_error(&e.to_string());
                Err(e)
            }
        }
    }
} 