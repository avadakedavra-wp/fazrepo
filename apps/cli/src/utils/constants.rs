pub const VERSION: &str = env!("CARGO_PKG_VERSION");
pub const APP_NAME: &str = "fazrepo";
pub const APP_DESCRIPTION: &str = "A CLI tool for full-stack project generation and package manager checking";

pub const DEFAULT_TEMPLATE: &str = "fullstack-nextjs";
pub const CONFIG_FILE: &str = ".fazrepo";

pub const SUPPORTED_PACKAGE_MANAGERS: &[&str] = &["npm", "yarn", "pnpm", "bun"]; 