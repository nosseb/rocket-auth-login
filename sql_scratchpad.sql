-- UPDATE users SET salt = convert_to(gen_salt('bf'), 'LATIN1') WHERE userid = 1
-- UPDATE users SET pass = convert_to(crypt('password', convert_from(users.salt, 'LATIN1')), 'LATIN1') WHERE userid = 1
-- SELECT u.userid, u.username, u.display FROM users u WHERE u.username = 'admin' AND 
--     u.pass = convert_to(
--         crypt(
--             'password', convert_from(u.salt, 'LATIN1')
--         )
--     , 'LATIN1')

INSERT INTO users (username, display, password, is_admin, pass, salt) VALUES (
    'andrew', 'Andrew Prindle', 'password', true,
    convert_to('password', 'LATIN1'), convert_to(gen_salt('bf'), 'LATIN1')
)