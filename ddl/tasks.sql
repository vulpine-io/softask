CREATE TABLE IF NOT EXISTS tasks.task
(
  task_id          BIGSERIAL PRIMARY KEY,

  creator_id       BIGINT      NOT NULL
    REFERENCES users."user" (user_id) ON DELETE RESTRICT,

  task_name_id     BIGINT      NOT NULL
    REFERENCES words.task_name (task_name_id) ON DELETE RESTRICT,

  task_description TEXT,

  created          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated          TIMESTAMPTZ,
  deleted          TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS step
(
  step_id     BIGSERIAL PRIMARY KEY,
  task_id     BIGINT      NOT NULL
    REFERENCES tasks.task (task_id) ON DELETE CASCADE,
  name        VARCHAR(64),
  description VARCHAR(512),
  position    INT2        NOT NULL,
  creator_id  BIGINT      NOT NULL
    REFERENCES users.user (user_id) ON DELETE RESTRICT,
  created     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated     TIMESTAMPTZ,
  deleted     TIMESTAMPTZ
);