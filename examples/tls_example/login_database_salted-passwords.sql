--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-15 00:08:44

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 198 (class 1259 OID 16525)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    userid oid NOT NULL,
    username character varying(30) NOT NULL,
    display character varying(60),
    password character varying(64) NOT NULL,
    is_admin boolean NOT NULL,
    salt bytea,
    pass bytea
);


--
-- TOC entry 197 (class 1259 OID 16523)
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2839 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_userid_seq OWNED BY users.userid;


--
-- TOC entry 2708 (class 2604 OID 16531)
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN userid SET DEFAULT nextval('users_userid_seq'::regclass);


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


--
-- TOC entry 2710 (class 2606 OID 16533)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- TOC entry 2711 (class 2620 OID 16575)
-- Name: users insert_users; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER insert_users BEFORE INSERT OR UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE users_password_insert();


-- Completed on 2017-11-15 00:08:44

--
-- PostgreSQL database dump complete
--

