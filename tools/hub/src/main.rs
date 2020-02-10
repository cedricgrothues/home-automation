mod config;
mod install;

extern crate clap;

use crate::install::install;

use ansi_term::Colour::Red;
use clap::{App, Arg, SubCommand};
use std::process::exit;

fn main() {
    let args = App::new("Home Automation's setup tool")
        .arg(
            Arg::with_name("v")
                .short("v")
                .help("Sets the level of verbosity"),
        )
        .subcommand(
            SubCommand::with_name("install")
                .about("Setup a new home hub at <path>")
                .arg(
                    Arg::with_name("path")
                        .help("Sets the install path to use")
                        .required(true),
                ),
        )
        .get_matches();

    if let ("install", Some(command)) = args.subcommand() {
        match config::read() {
            Ok(_) => println!("Read config"),
            Err(_) => println!("Read config"),
        }

        let path = command.value_of("path").expect("No path specified!");

        match install(path) {
            Ok(_) => println!(""),
            Err(error) => {
                println!(
                    "{} Failed to create a new hub:\n\t{}\n",
                    Red.bold().paint("error:"),
                    error
                );
                exit(64);
            }
        }
    }
}
