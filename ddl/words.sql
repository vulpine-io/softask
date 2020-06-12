CREATE TABLE IF NOT EXISTS words.task_name
(
  task_name_id BIGSERIAL PRIMARY KEY,
  value        VARCHAR(128) NOT NULL UNIQUE
)