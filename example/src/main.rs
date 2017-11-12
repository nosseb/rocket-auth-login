
#![feature(custom_derive)]
#![feature(plugin)]
#![plugin(rocket_codegen)]


extern crate rocket;
// extern crate rocket_contrib;
// extern crate rocket_simpleauth as auth;
extern crate serde;
#[macro_use] extern crate serde_derive;
extern crate rmp_serde as rmps;

#[macro_use] extern crate lazy_static;
extern crate regex;
extern crate time;

extern crate titlecase;
#[macro_use] extern crate serde_json;
extern crate htmlescape;

// use rocket_contrib::Template;
use rocket::{Request, Data, Outcome, Response};
use rocket::response::{content, NamedFile, Redirect, Flash, Responder, Content};
use rocket::response::content::Html;
use rocket::data::FromData;
use rocket::request::{FlashMessage, Form};
use rocket::http::{Cookie, Cookies, MediaType, ContentType, Status};
// let html = ContentType::HTML;
use std::path::{Path, PathBuf};

extern crate rocket_auth_login as auth;

use auth::*;
use auth::sanitization::*;
use auth::authorization::*;

mod administrator;
mod layout;

use administrator::*;
use layout::*;

const URL: &'static str = "http://localhost:8000";
const LOGIN_URL: &'static str = "http://localhost:8000/login";

#[get("/login", rank = 1)]
fn logged_in(user: AuthCont<AdministratorCookie>) -> Html<String> {
    layout("You are logged in.")
}
#[get("/login", rank = 2)]
fn login() -> Html<String> {
    layout(&layout_form(LOGIN_URL))
}

// if there is no user query string indicating the user attempted and failed to login
// display only the basic login screen
// #[get("/login", rank = 4)]
// fn retry_login() -> Html<String> {
//     layout(&layout_retry_form(LOGIN_URL, ""))
// }

// if there is a user query string, and an optional flash message
// display an optional flash message indicating why the login failed
// and the login screen with user filled in
#[get("/login?<user>")]
fn retry_login_user(user: UserQuery, flash_msg_opt: Option<FlashMessage>) -> Html<String> {
    // layout(&layout_retry_form(LOGIN_URL, user.user))
    let login_form = layout_retry_form(LOGIN_URL, &user.user);
    let alert;
    if let Some(flash) = flash_msg_opt {
        alert = alert_danger(flash.msg());
    } else { 
        alert = String::new();
    }
    let mut contents = String::with_capacity(login_form.len() + alert.len() + 20);
    contents.push_str(&alert);
    contents.push_str("\n");
    contents.push_str(&login_form);
    layout(&contents)
    
}

// if there is a flash message but no user query string
// display why the login failed and display the login screen
#[get("/login", rank = 3)]
fn retry_login_flash(flash_msg: FlashMessage) -> Html<String> {
    println!("Retrying login...");
    let login_form = layout_form(LOGIN_URL);
    let alert = alert_danger(flash_msg.msg());
    let mut contents = String::with_capacity(login_form.len() + alert.len() + 20);
    contents.push_str(&alert);
    contents.push('\n');
    contents.push_str(&login_form);
    layout(&contents)
}

#[post("/login", data = "<form>")]
fn process_login(form: Form<LoginCont<AdministratorForm>>, mut cookies: Cookies) -> Result<Redirect, Flash<Redirect>> {
    let inner = form.into_inner();
    // let login = inner.form();
    let login = inner.form;
    login.flash_redirect("/login", "/login", cookies)
}

#[get("/logout")]
fn logout(admin: Option<AdministratorCookie>, mut cookies: Cookies) -> Result<Flash<Redirect>, Redirect> {
    if let Some(a) = admin {
        cookies.remove_private(Cookie::named(AdministratorCookie::cookie_id()));
        // cookies.remove_private(Cookie::named("user_id"));
        Ok(Flash::success(Redirect::to("/"), "Successfully logged out."))
    } else {
        Err(Redirect::to("/login"))
    }
}


#[get("/")]
fn index(admin_opt: Option<AdministratorCookie>, flash_msg_opt: Option<FlashMessage>) -> Html<String> {
    let mut contents = String::with_capacity(300);
    if let Some(flash) = flash_msg_opt {
        match flash.name() {
            "success" => contents.push_str(&alert_success(flash.msg())),
            "warning" => contents.push_str(&alert_warning(flash.msg())),
            "error" => contents.push_str(&alert_danger(flash.msg())),
            _ => contents.push_str(&alert_info(flash.msg())),
        }
    }
    if let Some(admin) = admin_opt {
        contents.push_str(&format!("Welcome {}", admin.username));
    } else {
        contents.push_str(r#"<a href="/login">Login</a>"#);
    }
    layout(&contents)
}

#[get("/<file..>", rank=10)]
fn static_files(file: PathBuf) -> Option<NamedFile> {
    NamedFile::open(Path::new("static/").join(file)).ok()
}

fn main() {
    // println!("Hello, world!");
    
        rocket::ignite()
        // .manage(data::init_pg_pool())
        // .attach(Template::fairing())
        .mount("/", routes![
            logged_in,
            login,
            // retry_login,
            retry_login_user,
            retry_login_flash,
            process_login,
            logout,
            index,
            static_files
        ])
        .launch();
}
