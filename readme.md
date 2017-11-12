# Rocket Authentication / Login
Rocket-auth-login is a simple authnetication crate that provides some help creating and using user types.

For example you could create a regular User type and an elevated Admin type.  This crate defines three main traits that are used with two different custom types.

# Custom Data Structures
There are two data structures that you will have to implement:

## Cookie Data User Type
The `AuthorizeCookie` trait is used with a custom type that will be stored in the cookie.  The cookie is stored as text so the cookie user type will implement `store_cookie()` and `retrieve_cookie()` methods.  The data structure can hold any information, but will most likely contain the userid/username/email or any other information you wish to have available immediately without having to query a database.  Using Rocket's Private Cookies ensures authenticity so you can be sure the user is an administrator just by adding a request guard for the defined cookie user type.

```

    pub struct AdministratorCookie {
        pub userid: u32,
        pub username: String,
        pub display: Option<String>,
    }

```

## Login Form Data User Type
The `AuthorizeForm` trait is used with a custom type that stores and authenticates the login data.  It will hold the username and password in most cases.

```

    pub struct AdministratorForm {
        pub username: String,
        pub password: String,
    }
```

# Traits
## CookieId
The `cookieId` trait defines a single method, `cookie_id()`.  This method is used to provide the identifier for the cookie.

## AuthorizeCookie
The `AuthorizeCookie` contains three methods, `store_cookie()`, `retrieve_cookie()`, and `delete_cooke()`.  The first two must be implemented on the cookie user type, the last can be overridden if needed.

```
    

    // Replace AdministratorCookie with your cookie user type
    impl AuthorizeCookie for AdministratorCookie {
        fn store_cookie(&self) -> String {
            ::serde_json::to_string(self).expect("Could not serialize")
        }
    
        fn retrieve_cookie(string: String) -> Option<Self::CookieType> {
            let mut des_buf = string.clone();
            let des: Result<AdministratorCookie, _> = ::serde_json::from_str(&mut des_buf);
            if let Ok(cooky) = des {
                Some(cooky)
            } else {
                None
            }
        }
    }
```

## AuthorizeForm
The `AuthorizeForm` trait contains two important methods: `authenticate()` and `new_form()`.  `authenticate(&self) -> Result<Self::CookieType, AuthFail>` is used to authenticate submitted form data

```

    impl AuthorizeForm for AdministratorForm {
        type CookieType = AdministratorCookie;
        
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
```

# Example
The example directory contains a fully working example.   There are only really two files of importance, main.rs (which calls and demonstrates use of the custom user structures) and administrator.rs (which defines the custom user structures). The three rust files that used are:

- main.rs - calls rocket, adds some routes
- administrator.rs - defines the `AdministratorCookie` and `AdministratorForm` structures
- layout.rs - adds some basic HTML layout functions.  This is just for demonstration to make the example work, in a more complicated example Rocket_contrib's Templates would be used.

There are also css and javascript files used to style and add javascript form validation as well as sha-256 hashing of the password (as used in this example; if SSL is not being used it is better to hash the password then to send it as plain text).



