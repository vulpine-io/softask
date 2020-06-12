CREATE TABLE IF NOT EXISTS users.user
(
  -- Sequential user id
  user_id      BIGSERIAL PRIMARY KEY,

  -- User display name
  display_name VARCHAR(64)  NOT NULL,

  -- Twofish encrypted user email
  email        VARCHAR(128) NOT NULL UNIQUE,

  -- Sha256 hashed user password
  password     VARCHAR(64)  NOT NULL,

  -- user creation date
  created      TIMESTAMPTZ  NOT NULL DEFAULT now()
);