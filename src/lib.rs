
//! # Purpose
//! This crate includes traits and miscellaneous helpers
//! that help provide authentication to your rocket web app.
//! 
//! # Structure
//! The crate consists of an authorization module and a sanitization
//! helper module.  The authorization module provides two traits:
//! 
//! ## AuthorizeCookie
//! contains methods to store or retrieve a data structure from a cookie.
//! The `AuthorizeCookie` trait is implemented on a data structure that
//! contain all of data stored in the cookie, like username, display name,
//! email, etc.  Any data you wish to be readily available without an
//! expensive database lookup can be stored in the cookie data structure.
//! 
//! ## AuthorizeForm
//! contains methods to collect a data structure that contains the contents 
//! of a login form submission.  The credentials stored in the data structure 
//! are then authenticated and by using either the `flash_redirect()` or 
//! `redirect()` methods, the user can be redirected either to an admin 
//! dashboard for example or upon failure a retry login page.
//! 

#![feature(custom_derive)]
#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
extern crate regex;
#[macro_use] extern crate lazy_static;

extern crate htmlescape;
pub mod authorization;
pub mod sanitization;

