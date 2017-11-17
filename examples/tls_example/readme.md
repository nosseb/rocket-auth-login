% Rocket-auth-login Tls/SSL with Database Example

# TLS Setup
* The constants `URL` and `LOGIN_URL` in the example need to be changed to `https://` instead of `http://`
* The `AuthorizeForm` implementation for `AdministratorForm` should add a `flash_redirect()` and/or `redirect()` method (depending on what you need) to create the cookie with `secure` set to `true`
* In the private folder the ca_cert.pem ca_key.pem cert.pem and key.pem should contain your keys and certificates
* The Rocket.toml file should exist and set the certs and key options to:

```

    # Per Environment Configuration of TLS:
    [development]
    tls = { certs = "private\\certs.pem", key = "private\\key.pem" }
    [production]
    tls = { certs = "private\\certs.pem", key = "private\\key.pem" }

```

# Using The Example
The example is setup with three main routes:

* / - The index page, can be accessed at [https://localhost:8000/](https://localhost:8000/)
* /login - either displays a login form (or a retry login form) or once logged in displays user information.  Can be accessed at [https://localhost:8000/login](https://localhost:8000/login)
* /logout - if the user is logged in it removes the private cookie and returns to the login page.  It can be accessed at [https://localhost:8000/logout](https://localhost:8000/logout)


**Copyright Note**: The Rocket-auth-login crate and Rust code examples are licensed under the Apache 2.0 license.  However the layout/design in the examples was created by me.  You can use it however if you put in at least an HTML comment inside the HTML output saying Design &copy; 2017 Andrew Prindle.
The rest of the application you may use without any kind of credit displayed to users but must follow the terms of the Apache 2.0 license.
