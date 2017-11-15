--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-15 00:30:33

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
    salt bytea NOT NULL,
    pass bytea NOT NULL
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

INSERT INTO users (userid, username, display, password, is_admin, salt, pass) VALUES (2, 'andrew', 'Andrew Prindle', 'password', true, '\x24326124303624316c436f47614f73716d4f786c7a4e2f645275497065', '\x24326124303624316c436f47614f73716d4f786c7a4e2f6452754970654141505a36307774425678654a542f4e6f664d7435424f6e6e686856697975');
INSERT INTO users (userid, username, display, password, is_admin, salt, pass) VALUES (1, 'admin', 'Administrator', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', true, '\x243261243036244d654550752f76423658777579533950784c6c36612e', '\x243261243036244d654550752f76423658777579533950784c6c36612e2e6c6f4964524d70525179446941704d496a78384871465558357364684657');


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


-- Completed on 2017-11-15 00:30:33

--
-- PostgreSQL database dump complete
--

