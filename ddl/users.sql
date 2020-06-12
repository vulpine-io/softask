CREATE TABLE IF NOT EXISTS users.user
(
  -- Sequential user id
  user_id      BIGSERIAL PRIMARY KEY,

  -- User display name
  display_name VARCHAR(64)  NOT NULL,

  -- Twofish encrypted user email
  email        VARCHAR(128) NOT NULL UNIQUE,

  -- Sha256 hashed user password
  password     (64)  NOT NULL,

  -- user creation date
  created      TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS users.pw_resets
(
  token   VARCHAR(32) NOT NULL UNIQUE,

  user_id BIGINT      NOT NULL
    REFERENCES users.user (user_id) ON DELETE CASCADE,

  created TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS users.device
(
  user_id   BIGINT      NOT NULL
    REFERENCES users.user (user_id) ON DELETE CASCADE,
  device_id VARCHAR(64) NOT NULL UNIQUE,
  auto_auth BOOL        NOT NULL DEFAULT FALSE
);