use htmlescape::*;
use regex::Regex;

/// Sanitize usernames to prevent xss and other vulnerabilities
/// Use sanitize() when escaping text that may be included in a html attribute (like value="<text>")
/// 
/// Usernames get embedded in a form input value attribute like:
/// <input type="text" name="username" value="<username>">
/// where the <username> is whatever is in the page's query string or Cookie/FlashMessage
/// 
/// The normal htmlescape::encode_minimal() encodes basic html entities
/// while the htmlescape::encode_attribute() encodes those from encode_minimal plus more,
/// as well as any non alpha-numeric ascii characters are hex encoded ( &#x00 );
pub fn sanitize(string: &str) -> String {
    encode_attribute(string)
}


/// sanitize_text() is similar to sanitize() but only encodes a minimal set of html entities
/// Use this when escaping a block of text, not text that should be placed inside an html attribute (like value="")
pub fn sanitize_text(string: &str) -> String {
    encode_minimal(string)
}


/// Used to remove all non-hexadecimal characters from passwords
/// Passwords must be only hex characters as it is expecting a hash, like sha-256 or md5 for example
pub fn sanitize_password(string: &str) -> String {
    lazy_static! {
        static ref SANITARY_PASSWORD: Regex = Regex::new(r#"^[A-Fa-f0-9]+$"#).unwrap();
        static ref SANITIZE_PASSWORD: Regex = Regex::new(r#"[^A-Fa-f0-9]+"#).unwrap();
    }
    if SANITARY_PASSWORD.is_match(string) {
        string.to_string()
    } else {
        SANITIZE_PASSWORD.replace_all(string, "").to_string()
    }
}
