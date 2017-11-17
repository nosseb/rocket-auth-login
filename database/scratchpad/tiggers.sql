
CREATE OR REPLACE FUNCTION users_password_insert() RETURNS trigger AS $$
begin
  -- new.pass := convert_to(crypt(convert_from(new.pass || new.salt, 'LATIN1'), convert_from(new.salt, 'LATIN1')), 'LATIN1');
  new.pass := convert_to(crypt(convert_from(new.pass, 'LATIN1'), convert_from(new.salt, 'LATIN1')), 'LATIN1');
  return new;
end
$$ LANGUAGE plpgsql;

-- CREATE TRIGGER insert_users BEFORE INSERT OR UPDATE
--    ON users FOR EACH ROW EXECUTE PROCEDURE users_password_insert();


CREATE OR REPLACE FUNCTION users_hash_upsert() RETURNS trigger AS $$
begin
  new.pass_hash := crypt(new.pass_hash, crypt(new.pass_hash, new.pass_salt));
  return new;
end
$$ LANGUAGE plpgsql;

CREATE TRIGGER upsert_users BEFORE INSERT OR UPDATE
   ON users FOR EACH ROW EXECUTE PROCEDURE users_hash_upsert();



CREATE OR REPLACE FUNCTION users_hash_upsert() RETURNS trigger AS $$
begin
  if new.salt_hash != '' AND new.salt_hash != NULL then
    new.salt_hash := crypt(new.salt_hash, new.pass_salt);
  end if
  return new;
end
$$ LANGUAGE plpgsql;





