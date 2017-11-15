
use std::mem::transmute;
use rand::{thread_rng, Rng};
// use argon2rs;

// use argon2rs::{Argon2, defaults, Variant};

// pub fn hash_argon(password: &[u8], salt: u64) -> [u8; defaults::LENGTH] {
//     let mut out = [0; defaults::LENGTH];
//     let a2 = Argon2::default(Variant::Argon2i);
//     a2.hash(&mut out, password, salt_bytes(salt), &[], &[]);
//     out
// }

// pub fn argon_hash(password: , salt) {
//     let (password, salt) = ("argon2i!", "delicious salt");
//     // println!("argon2i(\"argon2i\", \"delicious\"):");
//     for byte in argon2rs::simple2i(&password, &salt).iter() {
//         print!("{:02x}", byte);
//     }
    
// }

// https://stackoverflow.com/a/29482767/7891095
// pub fn salt_bytes<'b>(salt: u64) -> &'b [u8] {
//     // let var1 =  12345678_u64;
//     let raw_bytes : [u8; 8] = unsafe { std::mem::transmute(salt) };
//     // for byte in &raw_bytes {
//     //     println!("{}", byte);
//     // }
//     raw_bytes
// }

// pub pass_vec(pass: &[u8]) -> Vec<u8> {
//     let mut v: Vec<u8> = Vec::new();
//     for b in pass {
//         v.push(b);
//     }
//     v
// }

// pub struct PassHash<'a> {
//     pub password: &'a [u8],
//     pub salt: u64,
// }

// impl PassHash {
//     pub fn new(pass: &[u8]) -> PassHash {
//         let rg = thread_rng();
//         let salt = rg.gen::<u64>();
//         PassHash {
//             password: pass,
//             salt,
//         }
//     }
    
// }