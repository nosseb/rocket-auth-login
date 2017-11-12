
use rocket;
use rocket::{Request, Data, Outcome, Response};
use ::rocket::config::{Config, Environment};
use rocket::data::FromData;
use rocket::http::{Cookie, Cookies, MediaType, ContentType, Status, RawStr};
use rocket::request::{FlashMessage, Form, FromRequest,FromForm, FormItems, FromFormValue, FromParam};
use rocket::response::{content, NamedFile, Redirect, Flash, Responder, Content};
use rocket::response::content::Html;

use auth::{authorization, sanitization};

/// The AdministratorCookie type is used to indicate a user has logged in as an administrator
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AdministratorCookie {
    pub userid: u32,
    pub username: String,
    pub display: Option<String>,
}

/// The AdministratorForm type is used to process a user attempting to login as an administrator
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AdministratorForm {
    pub username: String,
    pub password: String,
}

impl CookieId for AdministratorCookie {
    fn cookie_id<'a>() -> &'a str {
        "acid"
    }
}

impl CookieId for AdministratorForm {
    fn cookie_id<'a>() -> &'a str {
        "acid"
    }
} 

impl AuthorizeCookie for AdministratorCookie {
    type CookieType = AdministratorCookie;
    
    /// The store_cookie() method should contain code that
    /// converts the specified data structure into a string
    /// 
    /// This is likely to be achieved using one of the serde
    /// serialization crates.  Personally I would use either
    /// serde_json or serde's messagepack implementation ( rmp-serde [rmps]).
    /// 
    /// Json is portable and human readable.  
    ///
    /// MsgPack
    fn store_cookie(&self) -> String {
        String::from("This is my cooky")
    }
    fn retrieve_cookie(string: String) -> Option<Self::CookieType> {
        Some(
            AdministratorCookie {
                userid: 66,
                username: "andrew".to_string(),
                display: Some("Andrew Prindle".to_string()),
            }
        )
    }
}

impl AuthorizeForm for AdministratorForm {
    type CookieType = AdministratorCookie;
    
    // fn authenticate(&self) -> Result<Self::CookieType, (String, String)> {
    fn authenticate(&self) -> Result<Self::CookieType, AuthFail> {
        println!("Authenticating {} with password: {}", &self.username, &self.password);
        if &self.username == "administrator" && &self.password != "" {
            Ok(
                AdministratorCookie {
                    userid: 1,
                    username: "administrator".to_string(),
                    display: Some("Administrator".to_string()),
                }
            )
        } else {
            // Err(self.username.to_string(), "Incorrect username".to_string())
            Err(
                AuthFail::new(self.username.to_string(), "Incorrect username".to_string())
            )
        }
    }
    
    fn new_form(user: &str, pass: &str) -> Self {
        AdministratorForm {
            username: user.to_string(),
            password: pass.to_string(),
        }
    }
    
}

impl<'a, 'r> FromRequest<'a, 'r> for AdministratorCookie {
    type Error = ();

    fn from_request(request: &'a Request<'r>) -> ::rocket::request::Outcome<AdministratorCookie,Self::Error>{
        let cid = AdministratorCookie::cookie_id();
        let mut cookies = request.cookies();
        
        match cookies.get_private(cid) {
            Some(cookie) => Outcome::Success(
                AdministratorCookie::retrieve_cookie(cookie.value().to_string()),
                // AdministratorCookie {
                //     // Performance: find a way to remove the to_string()
                //     cookie: T::retrieve_cookie(cookie.value().to_string()),
                // }
            ),
            None => Outcome::Forward(())
        }
    }
}

