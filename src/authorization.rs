
use rocket::{Request, Outcome};
use rocket::response::{Redirect, Flash};
use rocket::request::{FromRequest, FromForm, FormItems};
use rocket::http::{Cookie, Cookies};

use std::marker::Sized;
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
}

pub trait AuthorizeCookie : CookieId {
    /// CookieType is the data type that will hold the cookie information
    type CookieType: AuthorizeCookie;
    
    /// Serialize the cookie data type - must be implemented by cookie data type
    fn store_cookie(&self) -> String;
    
    /// Deserialize the cookie data type - must be implemented by cookie data type
    fn retrieve_cookie(String) -> Option<Self> where Self: Sized;
    
    /// Deletes a cookie.  This does not need to be implemented.
    fn delete_cookie(mut cookies: Cookies) {
        cookies.remove_private( 
           Cookie::named( Self::cookie_id() )
        );
    }
}

pub trait AuthorizeForm : CookieId {
    // Todo: remove this associated type, no longer used
    type CookieType: AuthorizeCookie;
    
    /// Determine whether the login form structure containts
    /// valid credentials, otherwise send back the username and
    /// a message indicating why it failed in the `AuthFail` struct
    /// 
    /// Must be implemented on the login form structure
    fn authenticate(&self) -> Result<Self::CookieType, AuthFail>;
    
    /// Create a new login form Structure with 
    /// the specified username and password
    /// 
    /// Must be implemented on the login form structure
    fn new_form(&str, &str) -> Self;
    
    /// The `fail_url()` method is used to create a url that the user is sent
    /// to when the authentication fails.  The default implementation
    /// redirects the user to the /page?user=<ateempted_username>
    /// which enables the form to display the username that was attempted
    /// and unlike FlashMessages it will persist across refreshes
    fn fail_url(user: &str) -> String {
        let mut output = String::with_capacity(user.len() + 10);
        output.push_str("?user=");
        output.push_str(user);
        output
    }
    
    /// Redirect the user to one page on successful authentication or
    /// another page (with a `FlashMessage` indicating why) if authentication fails.
    /// 
    /// `FlashMessage` is used to indicate why the authentication failed
    /// this is so that the user can see why it failed but when they refresh
    /// it will disappear, enabling a clean start, but with the user name
    /// from the url's query string (determined by `fail_url()`)
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
                    let furl_qrystr = Self::fail_url(&fail.user);
                    furl.push_str(&furl_qrystr);
                }
                Err( Flash::error(Redirect::to(&furl), &fail.msg) )
            },
        }
    }
    
    /// Redirect the user to one page on successful authentication or
    /// another page if authentication fails.
    fn flash_redirect(&self, ok_redir: &str, err_redir: &str, mut cookies: Cookies) -> Result<Redirect, Redirect> {
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
                    let furl_qrystr = Self::fail_url(&fail.user);
                    furl.push_str(&furl_qrystr);
                }
                Err( Redirect::to(&furl), &fail.msg )
            },
        }
    }
}
    
impl<T: AuthorizeCookie + Clone> AuthCont<T> {
    pub fn cookie_data(&self) -> T {
        self.cookie.clone()
    }
}


impl<'a, 'r, T: AuthorizeCookie> FromRequest<'a, 'r> for AuthCont<T> {
    type Error = ();
    
    fn from_request(request: &'a Request<'r>) -> ::rocket::request::Outcome<AuthCont<T>,Self::Error>{
        let cid = T::cookie_id();
        let mut cookies = request.cookies();
        
        match cookies.get_private(cid) {
            Some(cookie) => {
                if let Some(cookie_deserialized) = T::retrieve_cookie(cookie.value().to_string()) {
                    Outcome::Success(
                        AuthCont {
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


