use std::fs::create_dir;

pub fn install(path: &str) -> Result<&str, std::io::Error> {
    let dir = create_dir(path)?;

    println!("Installing at path: {:?}", dir);

    Ok("heööp")
}
