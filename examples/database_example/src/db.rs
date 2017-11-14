
use rocket;
use ::rocket::request::{self, FromRequest, FromForm, FormItems};
use rocket::{Request, State, Outcome};
use ::rocket::config::{Config, Environment};
use rocket::http::Status;

use r2d2;
use r2d2_postgres;
use r2d2_postgres::{PostgresConnectionManager, TlsMode};
use postgres::Connection;
use postgres;
use postgres::params::{ConnectParams, Host};

use std::ops::Deref;
use std;
use std::env;
use dotenv::dotenv;

use super::PGCONN;

// Some links I found useful:
// 
// https://github.com/sfackler/rust-postgres/issues/128
// let stmt = try!(conn.prepare("INSERT INTO foo (bar) VALUES ('baz') RETURNING id"));
// let id: i32 = try!(stmt.query(&[])).iter().next().unwrap().get(0);
//
// https://sfackler.github.io/r2d2-postgres/doc/v0.9.2/r2d2_postgres/struct.PostgresConnectionManager.html
// https://medium.com/@aergonaut/writing-a-github-webhook-with-rust-part-1-rocket-4426dd06d45d
// https://github.com/aergonaut/railgun/blob/master/src/railgun/db.rs

/// Type alias for the r2d2 connection pool. Use this as a State<T> parameter
/// in handlers that need a database connection.
type Pool = r2d2::Pool<PostgresConnectionManager>;

/// Creates the database connection pool
pub fn init_pg_pool() -> Pool {
    let config = r2d2::Config::default();
    let manager = PostgresConnectionManager::new("postgres://postgres:andrew@localhost/login", TlsMode::None).unwrap();
    
    r2d2::Pool::new(config, manager).expect("Could not create database pool")
}

/// DbConn is a data structure that contains a database connection.
/// The DbConn also has a request guard that retrieves a connection
/// from the shared state when the route is called.
pub struct DbConn(
    pub r2d2::PooledConnection<PostgresConnectionManager>
);

/// Attempts to retrieve a single connection from the managed database pool. If
/// no pool is currently managed, fails with an `InternalServerError` status. If
/// no connections are available, fails with a `ServiceUnavailable` status.
impl<'a, 'r> FromRequest<'a, 'r> for DbConn {
    type Error = ();

    fn from_request(request: &'a Request<'r>) -> request::Outcome<DbConn, ()> {
        let pool = request.guard::<State<Pool>>()?;
        match pool.get() {
            Ok(conn) => Outcome::Success(DbConn(conn)),
            Err(_) => Outcome::Failure((Status::ServiceUnavailable, ()))
        }
    }
}

// For the convenience of using an &DbConn as a postgresql connection.
impl Deref for DbConn {
    // If using Sqlite
    // type Target = SqliteConnection;
    type Target = Connection;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

// Non-shared-state database connection examples
// The dotenv crate is used to store an env var called DATABASE_URL in a .env file
// which is then loaded into the environmental variables.
// pub fn establish_connection() -> Connection {
//     dotenv().ok();
//     let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
//     // PgConnection::establish(&database_url).expect("Error connecting to {}", database_url);
//     // Connection::connect("postgres://postgres@localhost:5433", TlsMode::None).unwrap()
//     Connection::connect(database_url, postgres::TlsMode::None).unwrap()
// }




