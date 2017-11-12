
#![feature(custom_derive)]
#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
extern crate regex;
#[macro_use] extern crate lazy_static;

extern crate htmlescape;

// use rocket::{Request, Data, Outcome, Response};
// use rocket::response::{content, NamedFile, Redirect, Flash, Responder, Content};
// use rocket::response::content::Html;
// use rocket::data::FromData;
// use rocket::request::{FlashMessage, Form};
// use rocket::http::{Cookie, Cookies, Status};
// // let html = ContentType::HTML;
// use std::path::{Path, PathBuf};

pub mod authorization;
// pub mod administrator;
pub mod sanitization;

// use administrator::*;
// use layout::*;


// #[cfg(test)]
// mod tests {
//     #[test]
//     fn it_works() {
//         assert_eq!(2 + 2, 4);
//     }
// }
