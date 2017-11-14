--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-12 21:32:22

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
-- TOC entry 2794 (class 0 OID 16525)
-- Dependencies: 197
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO users (userid, username, display, password, is_admin) VALUES (1, 'admin', 'Administrator', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', true);


--
-- TOC entry 2800 (class 0 OID 0)
-- Dependencies: 196
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_userid_seq', 1, false);


-- Completed on 2017-11-12 21:32:22

--
-- PostgreSQL database dump complete
--

