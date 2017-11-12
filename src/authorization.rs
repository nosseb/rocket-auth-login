
use rocket::{Request, Data, Outcome, Response};
use rocket::response::{content, NamedFile, Redirect, Flash, Responder, Content};
use rocket::response::content::Html;
use rocket::data::FromData;
use rocket::request::{FlashMessage, Form, FromRequest, FromForm, FormItems};
use rocket::http::{Cookie, Cookies, MediaType, ContentType, Status};

use sanitization::*;

#[derive(Debug, Clone, FromForm)]
pub struct UserQuery {
    pub user: String,
}

#[derive(Debug, Clone)]
pub struct AuthCont<T: AuthorizeCookie> {
    pub cookie: T,
}

#[derive(Debug, Clone)]
pub struct AuthFail {
    pub user: String,
    pub msg: String,
}

impl AuthFail {
    pub fn new(user: String, msg: String) -> AuthFail {
        AuthFail {
            user,
            msg,
        }
    }
}


#[derive(Debug, Clone)]
pub struct LoginCont<T: AuthorizeForm> {
    pub form: T,
}

impl<T: AuthorizeForm + Clone> LoginCont<T> {
    pub fn form(&self) -> T {
        self.form.clone()
    }
}

pub trait CookieId {
    fn cookie_id<'a>() -> &'a str {
        "sid"
    }
    // fn add_cookie(mut cookies: Cookies, contents: &str) {
    //     cookies.add_private(Cookie::new(Self::cookie_id(), contents));
    // }
}

pub trait AuthorizeCookie : CookieId {
    // type CookieType: AuthorizeCookie;
    fn store_cookie(&self) -> String;
    // fn retrieve_cookie(String) -> Option<CookieType>;
    fn retrieve_cookie(String) -> Option<Self>;
    fn delete_cookie(mut cookies: Cookies) {
        cookies.remove_private( 
           Cookie::named( Self::cookie_id() )
        );
    }
}

pub trait AuthorizeForm : CookieId {
    type CookieType: AuthorizeCookie;
    
    // fn authenticate(&self) -> Result<Self::CookieType, (String, String)>;
    fn authenticate(&self) -> Result<Self::CookieType, AuthFail>;
    
    fn new_form(&str, &str) -> Self;
    
    /// The fail_url() method is used to create a url that the user is sent
    /// to when the authentication fails.  The
    // fn fail_url(url: &str, user: &str) -> String {
        // let mut output = String::with_capacity(url.len() + user.len() + 10);
        // output.push_str(url);
    fn fail_url(user: &str) -> String {
        let mut output = String::with_capacity(user.len() + 10);
        output.push_str("?user=");
        output.push_str(user);
        output
    }
    
    fn flash_redirect(&self, ok_redir: &str, err_redir: &str, mut cookies: Cookies) -> Result<Redirect, Flash<Redirect>> {
        match self.authenticate() {
            Ok(cooky) => {
                let cid = Self::cookie_id();
                let contents = cooky.store_cookie();
                cookies.add_private(Cookie::new(cid, contents));
                Ok(Redirect::to(ok_redir))
            },
            Err(fail) => {
                let mut furl = String::from(err_redir);
                if &fail.user != "" {
                    // let furl_qrystr = Self::fail_url(ename, emsg);
                    let furl_qrystr = Self::fail_url(&fail.user);
                    furl.push_str(&furl_qrystr);
                }
                Err( Flash::error(Redirect::to(&furl), &fail.msg) )
            },
        }
    }
    
    // fn redirect(&self, ok_redir: &str, err_redir: &str, mut cookies: Cookies) -> Result<Redirect, Redirect> {
        // ...
        // same code as flash_redirect except
        // just redirect, no flash messages
    // }
}

// impl<T: AuthorizeCookie> AuthCont<T> {
impl<T: AuthorizeCookie + Clone> AuthCont<T> {
    pub fn cookie_data(&self) -> T {
        self.cookie.clone()
    }
}

// impl<A: AuthorizeForm> LoginCont<A> {
//     pub fn redirect() -> Result
// }


impl<'a, 'r, T: AuthorizeCookie> FromRequest<'a, 'r> for AuthCont<T> {
    type Error = ();

    fn from_request(request: &'a Request<'r>) -> ::rocket::request::Outcome<AuthCont<T>,Self::Error>{
        let cid = T::cookie_id();
        let mut cookies = request.cookies();
        
        match cookies.get_private(cid) {
            // Some(cookie) => Outcome::Success(
            //     AuthCont {
            //         // Performance: find a way to remove the to_string()
            //         cookie: T::retrieve_cookie(cookie.value().to_string()),
            //     }
            // ),
            Some(cookie) => {
                if let Some(cookie_deserialized) = T::retrieve_cookie(cookie.value().to_string()) {
                    Outcome::Success(
                        AuthCont {
                            // Performance: find a way to remove the to_string()
                            cookie: cookie_deserialized,
                        }
                    )
                } else {
                    Outcome::Forward(())
                }
            },
            None => Outcome::Forward(())
        }
    }
}


impl<'f, A: AuthorizeForm> FromForm<'f> for LoginCont<A> {
    type Error = &'static str;
    
    fn from_form(form_items: &mut FormItems<'f>, _strict: bool) -> Result<Self, Self::Error> {
        // let mut user_pass = HashMap::new();
        let mut user: String = String::new();
        let mut pass: String = String::new();
        for (key,value) in form_items {
            match key.as_str(){
                "username" => {
                    user = sanitize(&value.url_decode().unwrap_or(String::new()));
                },
                "password" => {
                    pass = sanitize_password(&value.url_decode().unwrap_or(String::new()));
                },
                _ => {},
            }
        }
        Ok(
            LoginCont {
                form: A::new_form(&user, &pass),
            }
        )
    }
}


