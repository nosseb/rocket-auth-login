
#![feature(custom_derive)]
#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
extern crate regex;
#[macro_use] extern crate lazy_static;

extern crate htmlescape;
pub mod authorization;
pub mod sanitization;

