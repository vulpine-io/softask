CREATE TABLE IF NOT EXISTS common.task_name
(
  task_name_id BIGSERIAL PRIMARY KEY,
  value        VARCHAR(128) NOT NULL UNIQUE
);
