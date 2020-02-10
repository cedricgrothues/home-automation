extern crate dirs;

use std::fs::create_dir;
use std::path::Path;

static HEADER: &str = "// This is a generated file; do not edit or check into version control.\n";

pub fn install(path: &str) -> Result<(), std::io::Error> {
    let home = dirs::home_dir().expect("User has no home directory!");

    let config_dir = home.join(".hub");
    create_dir(&config_dir)?;

    let mut out = String::from(HEADER);

    let install_dir = Path::new(path).canonicalize()?;

    out.push_str(format!("INSTALL_DIR={}\n", install_dir.to_str().unwrap()).as_str());

    std::fs::write(&config_dir.join("generated.config"), out)?;

    Ok(())
}
