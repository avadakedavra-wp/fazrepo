use crate::services::{PackageManagerService, OutputService};
use anyhow::Result;

pub struct CheckCommand {
    package_manager_service: Box<dyn PackageManagerService>,
    output_service: Box<dyn OutputService>,
}

impl CheckCommand {
    pub fn new(
        package_manager_service: Box<dyn PackageManagerService>,
        output_service: Box<dyn OutputService>,
    ) -> Self {
        Self {
            package_manager_service,
            output_service,
        }
    }

    pub async fn execute(&self, detailed: bool, only: Option<&str>) -> Result<()> {
        let all_managers = self.package_manager_service.get_supported_managers();
        
        let managers_to_check = if let Some(only_list) = only {
            let selected: Vec<&str> = only_list.split(',').map(|s| s.trim()).collect();
            all_managers
                .into_iter()
                .filter(|pm| selected.contains(&pm.name.as_str()))
                .collect()
        } else {
            all_managers
        };

        if managers_to_check.is_empty() {
            self.output_service.display_error("No valid package managers specified");
            return Ok(());
        }

        let results = self.package_manager_service.check_managers(managers_to_check).await;
        self.output_service.display_package_manager_results(&results, detailed);

        Ok(())
    }
} 