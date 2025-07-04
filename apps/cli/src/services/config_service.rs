use crate::models::AppConfig;
use anyhow::Result;
use serde_json;
use std::fs;
use std::path::Path;

pub trait ConfigService {
    fn load_config(&self) -> Result<AppConfig>;
    fn save_config(&self, config: &AppConfig) -> Result<()>;
    fn init_config(&self) -> Result<AppConfig>;
    fn get_config_path(&self) -> String;
}

#[derive(Clone)]
pub struct DefaultConfigService;

impl DefaultConfigService {
    pub fn new() -> Self {
        Self
    }

    fn get_config_file_path(&self) -> String {
        ".fazrepo".to_string()
    }
}

impl ConfigService for DefaultConfigService {
    fn load_config(&self) -> Result<AppConfig> {
        let config_path = self.get_config_file_path();
        
        if !Path::new(&config_path).exists() {
            return Ok(AppConfig::new());
        }

        let content = fs::read_to_string(&config_path)?;
        let config: AppConfig = serde_json::from_str(&content)?;
        Ok(config)
    }

    fn save_config(&self, config: &AppConfig) -> Result<()> {
        let config_path = self.get_config_file_path();
        let content = serde_json::to_string_pretty(config)?;
        fs::write(&config_path, content)?;
        Ok(())
    }

    fn init_config(&self) -> Result<AppConfig> {
        let mut config = AppConfig::new();
        config.initialized = true;
        
        // Add default templates
        config = config
            .with_template("fullstack-nextjs", "Full-stack Next.js application")
            .with_template("api-express", "Express.js API with TypeScript");

        self.save_config(&config)?;
        Ok(config)
    }

    fn get_config_path(&self) -> String {
        self.get_config_file_path()
    }
} 