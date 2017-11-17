-- UPDATE users SET salt = convert_to(gen_salt('bf'), 'LATIN1') WHERE userid = 1
-- UPDATE users SET pass = convert_to(crypt('password', convert_from(users.salt, 'LATIN1')), 'LATIN1') WHERE userid = 1
-- SELECT u.userid, u.username, u.display FROM users u WHERE u.username = 'admin' AND 
--     u.pass = convert_to(
--         crypt(
--             'password', convert_from(u.salt, 'LATIN1')
--         )
--     , 'LATIN1')

-- Create a new user
INSERT INTO users (username, display, password, is_admin, pass, salt) VALUES (
    'andrew', 'Andrew Prindle', 'password', true,
    convert_to('password', 'LATIN1'), convert_to(gen_salt('bf'), 'LATIN1')
)

-- View salts and password hashes for all users
SELECT encode(u.pass, 'hex') as pass, encode(u.salt, 'hex') as salt FROM users u

-- Update salt for all users
UPDATE users SET salt = convert_to(gen_salt('bf'), 'LATIN1')

-- Set password for all users
UPDATE users SET pass = 'password';

-- --------------------------------- --

UPDATE users SET pass_salt = gen_salt('bf')

UPDATE users SET pass_hash = 'password'









