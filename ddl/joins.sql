CREATE TABLE IF NOT EXISTS joins.user_to_task
(
  user_id BIGINT NOT NULL
    REFERENCES users."user" (user_id) ON DELETE CASCADE,
  task_id BIGINT NOT NULL
    REFERENCES tasks.task (task_id) ON DELETE CASCADE
);

ALTER TABLE joins.user_to_task
  ADD CONSTRAINT jutt_unique
    UNIQUE (user_id, task_id);