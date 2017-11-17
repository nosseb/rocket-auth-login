--
-- PostgreSQL database dump
--

-- Dumped from database version 10.0
-- Dumped by pg_dump version 10.0

-- Started on 2017-11-16 05:47:27

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE login;
--
-- TOC entry 2858 (class 1262 OID 16522)
-- Name: login; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE login WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';


\connect login

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12924)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2861 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 16537)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2862 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

--
-- TOC entry 204 (class 1255 OID 16607)
-- Name: proc_users_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_users_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    -- Hash the password with a newly generated salt
    -- crypt() will store the hash and salt (and the algorithm and iterations) in the column
    new.salt_hash := crypt(new.salt_hash, gen_salt('bf', 8));
  return new;
end
$$;


--
-- TOC entry 235 (class 1255 OID 16608)
-- Name: proc_users_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION proc_users_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  -- Only hash a new password if updating a password that is not blank or null
  if new.salt_hash != '' AND new.salt_hash != NULL then
    -- If the query specifies a password to update call crypt on the new password
    -- which should be plaintext.  Crypt stores the salt and the hash (and algorithm used)
    -- so when called it will extract the salt from the previous password and use
    -- the existing salt to hash the new password.
    new.salt_hash := crypt(new.salt_hash, new.pass_salt);
  else
    -- Otherwise if there was no password specified use the old one
    new.salt_hash := old.salt_hash;
  end if;
  return new;
end
$$;



--
-- TOC entry 199 (class 1259 OID 16611)
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 200 (class 1259 OID 16622)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    userid oid DEFAULT nextval('users_userid_seq'::regclass) NOT NULL,
    username character varying(30) NOT NULL,
    display character varying(60),
    is_admin boolean NOT NULL,
    salt_hash text NOT NULL
);



--
-- TOC entry 2863 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--
-- ALTER SEQUENCE users_userid_seq OWNED BY users.userid;

--
-- TOC entry 2719 (class 2604 OID 16531)
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: -
--
-- ALTER TABLE ONLY users ALTER COLUMN userid SET DEFAULT nextval('users_userid_seq'::regclass);

--
-- TOC entry 2853 (class 0 OID 16622)
-- Dependencies: 200
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

-- INSERT INTO u (userid, username, display, is_admin, salt_hash) VALUES (1, 'andrew', 'Andrew Prindle', true, '$2a$08$Or1OXHATQ.0wUoTSbU/JnuMhMILao9MU2aCB5uZB0/ELsLNC9qvji');
-- INSERT INTO u (userid, username, display, is_admin, salt_hash) VALUES (2, 'admin', 'Administrator', true, '$2a$08$UW3ta.wuNHbBamnEPLqlh.65VuU1HYOd4IZhjZQJdY1JoxM9JSMKm');
-- INSERT INTO u (userid, username, display, is_admin, salt_hash) VALUES (3, 'colexic', 'Coley Poley Oley', false, '$2a$08$beARJeX6W/CHKXQjLTwtUeE8b2VIHPkioP4Vd/gQMqrnlILNvntpO');
-- INSERT INTO u (userid, username, display, is_admin, salt_hash) VALUES (4, 'alex', 'Alex Pawb', false, '$2a$08$beARJeX6W/CHKXQjLTwtUeE8b2VIHPkioP4Vd/gQMqrnlILNvntpO');

INSERT INTO users (userid, username, display, is_admin, salt_hash) VALUES (1, 'andrew', 'Andrew Prindle', true, 'password');
INSERT INTO users (userid, username, display, is_admin, salt_hash) VALUES (2, 'admin', 'Administrator', true, 'password');
INSERT INTO users (userid, username, display, is_admin, salt_hash) VALUES (3, 'colexic', 'Coley Poley Oley', false, 'password');
INSERT INTO users (userid, username, display, is_admin, salt_hash) VALUES (4, 'alex', 'Alex Pawb', false, 'password');


--
-- TOC entry 2864 (class 0 OID 0)
-- Dependencies: 199
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_userid_seq', 3, true);


--
-- TOC entry 2724 (class 2606 OID 16630)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- TOC entry 2727 (class 2620 OID 16631)
-- Name: users trigger_users_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_users_insert BEFORE INSERT ON u FOR EACH ROW EXECUTE PROCEDURE proc_users_insert();


--
-- TOC entry 2728 (class 2620 OID 16632)
-- Name: users trigger_users_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_users_update BEFORE UPDATE ON u FOR EACH ROW EXECUTE PROCEDURE proc_users_update();



--
-- TOC entry 2860 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: -
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-11-16 05:47:27

--
-- PostgreSQL database dump complete
--

