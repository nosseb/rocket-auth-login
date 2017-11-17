% Rocket-auth-login Database Example

# Database Example Setup
First this particular example uses a postgresql database.  You must have postgresql installed on your machine.

## Database Setup Instructions
1. Go to the directory containing the `create_login.sql` file
2. Run: `psql postgresql://postgres@localhost` where `postgres@localhost` is the username and host address
3. Enter your password
4. Type: `\i create_login.sql` to run the script that will create:
    * The pgcrypto extension 
    * The `login` database
    * A `sequence` for the `userid` auto-incrementing primary key column
    * A `users` table
    * A few sample rows, all have the password set to "password".  This includes an admin user.
    * A `stored procedure` and `trigger` for inserting new users; this is to generate a password salt and hash the password with the generated salt.  The hash and salt (and the hash algorithm) are all stored in the `salt_hash` column, which is a secure way of storing the password.
    * A `stored procedure` and `trigger` for updating the password hash.

```

    c:\> cd <directory of create_login.sql>
    c:\rocket-auth-login\database\> psql postgresql://postgres@localhost
    Password: <your password>
    \i create_login.sql

```


# **Login** Database
## Table: Users

| Column Name | Data Type | Length | Null | Primary Key |
|-------------|-----------|-------|------|--------------|
| userid | Serial* | | Not Null | Primary Key |
| username | Character Varying | 30 | Not Null | |
| display | Character Varying | 60 | Nullable | |
| is_admin | boolean | | Not Null | |
| hash_salt | text | | Not Null | |

The database comes with an administrator user that looks like:

| Userid | Username | Display| hash_salt | Is Admin |
|--------|-----------|---------|----------|-----------|
| 1  |  admin | Administrator | password* | true |

Notes: * = The password is stored with a hash and salt using the pgcrypto crypt() function, which stores the algorithm used, the salt, and the hash.  This prevents rainbow table attacks.

5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8


# Using The Example
The example is setup with three main routes:

* **/** - The index page, can be accessed at [http://localhost:8000/](http://localhost:8000/)
* **/login** - either displays a login form (or a retry login form) or once logged in displays user information.  Can be accessed at [http://localhost:8000/login](http://localhost:8000/login)
* **/logout** - if the user is logged in it removes the private cookie and returns to the login page.  It can be accessed at [http://localhost:8000/logout](http://localhost:8000/logout)


**Copyright Note**: The Rocket-auth-login crate and Rust code examples are licensed under the Apache 2.0 license.  However the layout/design in the examples was created by me.  You can use it however if you put in at least an HTML comment inside the HTML output saying Design &copy; 2017 Andrew Prindle.
The rest of the application you may use without any kind of credit displayed to users but must follow the terms of the Apache 2.0 license.
