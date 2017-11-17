CREATE OR REPLACE FUNCTION proc_u_upsert() RETURNS trigger AS $$
begin
  -- Only hash a new password if updating a password that is not blank or null
  if TG_OP = 'UPDATE' AND  new.salt_hash != '' AND new.salt_hash != NULL then
    -- If the query specifies a password to update call crypt on the new password
    -- which should be plaintext.  Crypt stores the salt and the hash (and algorithm used)
    -- so when called it will extract the salt from the previous password and use
    -- the existing salt to hash the new password.
    new.salt_hash := crypt(new.salt_hash, new.pass_salt);
  elsif TG_OP = 'INSERT' then
    -- If inserting a new user, hash the password with a newly generated salt
    -- crypt() will store the hash and salt (and the algorithm and iterations) in the column
    new.salt_hash := crypt(new.salt_hash, gen_salt('bf', 8));
  end if
  return new;
end
$$ LANGUAGE plpgsql;