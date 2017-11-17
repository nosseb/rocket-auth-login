--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-16 05:42:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 2853 (class 0 OID 16622)
-- Dependencies: 200
-- Data for Name: u; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO u (userid, username, display, is_admin, salt_hash) VALUES (1, 'andrew', 'Andrew Prindle', true, '$2a$08$Or1OXHATQ.0wUoTSbU/JnuMhMILao9MU2aCB5uZB0/ELsLNC9qvji');
INSERT INTO u (userid, username, display, is_admin, salt_hash) VALUES (2, 'admin', 'Administrator', true, '$2a$08$UW3ta.wuNHbBamnEPLqlh.65VuU1HYOd4IZhjZQJdY1JoxM9JSMKm');
INSERT INTO u (userid, username, display, is_admin, salt_hash) VALUES (3, 'colexic', 'Coley Poley Oley', false, '$2a$08$beARJeX6W/CHKXQjLTwtUeE8b2VIHPkioP4Vd/gQMqrnlILNvntpO');


--
-- TOC entry 2851 (class 0 OID 16525)
-- Dependencies: 198
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO users (userid, username, display, password, is_admin, salt, pass, pass_hash, pass_salt) VALUES (2, 'andrew', 'Andrew Prindle', 'password', true, '\x24326124303624316c436f47614f73716d4f786c7a4e2f645275497065', '\x24326124303624316c436f47614f73716d4f786c7a4e2f645275497065672e5052535141494d6d433850724b48506f6b334269304674567a2e477379', '$2a$06$TF2wXunMzGeRaDVCv6fnUuFl8XqNv91gLjTFMyDuN4LvrcpcfMOby', '$2a$06$TF2wXunMzGeRaDVCv6fnUu');
INSERT INTO users (userid, username, display, password, is_admin, salt, pass, pass_hash, pass_salt) VALUES (1, 'admin', 'Administrator', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', true, '\x243261243036244d654550752f76423658777579533950784c6c36612e', '\x243261243036244d654550752f76423658777579533950784c6c36612e62496f373333544b4550385462662e4f3653484150674a692e6d5662303779', '$2a$06$Z1L0z35zMwKWNk4ctedbbOrCppaJq43oL0c4pqfn3WeC6Q7eeDz4e', '$2a$06$Z1L0z35zMwKWNk4ctedbbO');


--
-- TOC entry 2864 (class 0 OID 0)
-- Dependencies: 199
-- Name: u_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('u_userid_seq', 3, true);


--
-- TOC entry 2865 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_userid_seq', 3, true);


-- Completed on 2017-11-16 05:42:31

--
-- PostgreSQL database dump complete
--

