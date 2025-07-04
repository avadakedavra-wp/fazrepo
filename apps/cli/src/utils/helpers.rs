use std::path::Path;

pub fn is_valid_project_name(name: &str) -> bool {
    if name.is_empty() {
        return false;
    }

    if name.contains(char::is_whitespace) {
        return false;
    }

    if name.chars().any(|c| !c.is_alphanumeric() && c != '-' && c != '_') {
        return false;
    }

    true
}

pub fn sanitize_project_name(name: &str) -> String {
    name.to_lowercase()
        .chars()
        .map(|c| if c.is_alphanumeric() || c == '-' || c == '_' { c } else { '-' })
        .collect()
}

pub fn ensure_directory_exists(path: &Path) -> std::io::Result<()> {
    if !path.exists() {
        std::fs::create_dir_all(path)?;
    }
    Ok(())
}

pub fn get_platform_command(base_command: &str) -> String {
    if cfg!(target_os = "windows") {
        format!("{}.cmd", base_command)
    } else {
        base_command.to_string()
    }
} 