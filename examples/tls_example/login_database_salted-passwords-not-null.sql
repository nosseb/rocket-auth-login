--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-15 00:13:49

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
-- TOC entry 2834 (class 0 OID 16525)
-- Dependencies: 198
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO users (userid, username, display, password, is_admin, salt, pass) VALUES (2, 'andrew', 'Andrew Prindle', 'password', true, '\x243261243036245770795675656f7050756345655a424d4d6e52684f65', '\x243261243036245770795675656f7050756345655a424d4d6e52684f65635745744b6e41627654537377794b4743663870324d724b44643931437332');
INSERT INTO users (userid, username, display, password, is_admin, salt, pass) VALUES (1, 'admin', 'Administrator', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', true, '\x243261243036246c6c386153473566483233316170756e46415167544f', '\x243261243036246c6c386153473566483233316170756e46415167544f6d77385a43637854565634577749444e465759786564464b30334e78504a71');


--
-- TOC entry 2840 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_userid_seq', 2, true);


-- Completed on 2017-11-15 00:13:49

--
-- PostgreSQL database dump complete
--

