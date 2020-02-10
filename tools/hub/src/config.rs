extern crate dirs;

// use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufRead};

pub fn read() -> Result<(), std::io::Error> {
    let home = dirs::home_dir().expect("user has no home directory");

    let file = File::open(home.join(".hub/generated.config"))?;

    // let mut config: HashMap<&str, &str> = HashMap::new();

    for line in io::BufReader::new(file).lines() {
        let line = line.expect("could not read line");

        if line.starts_with("//") {
            continue;
        }

        // let args = &line.split("=");
        // let args: Vec<&str> = args.collect();

        // if args.len() < 2 {
        //     continue;
        // }

        // config.insert(args[0], args[1]);
    }

    Ok(())
}
