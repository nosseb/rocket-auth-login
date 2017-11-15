
CREATE OR REPLACE FUNCTION users_password_insert() RETURNS trigger AS $$
begin
  -- new.pass := convert_to(crypt(convert_from(new.pass || new.salt, 'LATIN1'), convert_from(new.salt, 'LATIN1')), 'LATIN1');
  new.pass := convert_to(crypt(convert_from(new.pass, 'LATIN1'), convert_from(new.salt, 'LATIN1')), 'LATIN1');
  return new;
end
$$ LANGUAGE plpgsql;

-- CREATE TRIGGER insert_users BEFORE INSERT OR UPDATE
--    ON users FOR EACH ROW EXECUTE PROCEDURE users_password_insert();
