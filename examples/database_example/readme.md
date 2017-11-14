% Rocket-auth-login Database Example

# Database Example Setup
First this particular example uses a postgresql database.  You must have postgresql installed on your machine.

Run the login_database.sql in the database example root.  If that fails recreate the table to match the following:

## Login Database
* Database name: **login**

## Users Table
* Table name: **users**

| Column Name | Data Type | Length | Null | Primary Key |
|-------------|-----------|-------|------|--------------|
| userid | Serial* | | Not Null | Primary Key |
| username | Character Varying | 30 | Not Null | |
| display | Character Varying | 60 | Nullable | |
| password | Character Varying | 64 | Not Null | |
| is_admin | boolean | | Not Null | |




Notes: * = the userid column is created as a serial data type which makes it auto increment, however it makes the column an integer, which in Rust is (I believe) an i64, and in the example we are using u32.  So after creating the column change the column from an integer to an oid data type which is a u32 in Rust.


By default there is one entry:

| Userid | Username | Display| Password | Is Admin |
|--------|-----------|---------|----------|-----------|
| 0  |  admin | Administrator | sha256(password)* | true |

Notes: * = The password for the admin user is stored as a sha-256 hash.  The original text is password.  The actual text stored in this column is:

5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8


# Using The Example
The example is setup with three main routes:

* / - The index page, can be accessed at [http://localhost:8000/](http://localhost:8000/)
* /login - either displays a login form (or a retry login form) or once logged in displays user information.  Can be accessed at [http://localhost:8000/login](http://localhost:8000/login)
* /logout - if the user is logged in it removes the private cookie and returns to the login page.  It can be accessed at [http://localhost:8000/logout](http://localhost:8000/logout)

Copyright Note: the design was created by me.  You can use it however if you do you put in at least an HTML comment inside the HTML output saying Design &copy; 2017 Andrew Prindle.
The rest of the application you may use without any kind of credit displayed to users but must follow the terms of the Apache 2.0 license.
