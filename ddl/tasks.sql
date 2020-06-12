CREATE TABLE IF NOT EXISTS task
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
)