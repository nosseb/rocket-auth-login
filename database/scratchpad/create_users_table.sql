
-- Sequence: public.u_userid_seq
CREATE SEQUENCE public.u_userid_seq
    CYCLE
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public.u_userid_seq
    OWNER TO postgres;

-- Table: public.u
DROP TABLE public.u;

CREATE TABLE public.u
(
    userid oid NOT NULL DEFAULT nextval('u_userid_seq'::regclass),
    username character varying(30) COLLATE pg_catalog."default" NOT NULL,
    display character varying(60) COLLATE pg_catalog."default",
    is_admin boolean NOT NULL,
    salt_hash text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT u_pkey PRIMARY KEY (userid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.u
    OWNER to postgres;
    
-- Forgot to make it NOT NULL earlier
-- ALTER TABLE u ALTER salt_hash SET NOT NULL

CREATE OR REPLACE FUNCTION proc_u_insert() RETURNS trigger AS $$
begin
    -- Hash the password with a newly generated salt
    -- crypt() will store the hash and salt (and the algorithm and iterations) in the column
    new.salt_hash := crypt(new.salt_hash, gen_salt('bf', 8));
  return new;
end
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION proc_u_update() RETURNS trigger AS $$
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
$$ LANGUAGE plpgsql;


-- Trigger: trigger_u_insert
-- DROP TRIGGER trigger_u_insert ON public.u;

CREATE TRIGGER trigger_u_insert
    BEFORE INSERT
    ON public.u
    FOR EACH ROW
    EXECUTE PROCEDURE public.proc_u_insert();


-- Trigger: trigger_u_update
-- DROP TRIGGER trigger_u_update ON public.u;

CREATE TRIGGER trigger_u_update
    BEFORE UPDATE 
    ON public.u
    FOR EACH ROW
    EXECUTE PROCEDURE public.proc_u_update();
    
    
    
    
    
    
    
    
    