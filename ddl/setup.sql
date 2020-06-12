CREATE SCHEMA IF NOT EXISTS common;
CREATE SCHEMA IF NOT EXISTS joins;
CREATE SCHEMA IF NOT EXISTS logs;
CREATE SCHEMA IF NOT EXISTS tasks;
CREATE SCHEMA IF NOT EXISTS users;

/*--------------------------------------------------------*\
| Task Names                                               |
|                                                          |
| The number of tasks should be significantly greater than |
| the number of unique task names.                         |
\*--------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS common.task_name
(
  task_name_id BIGSERIAL PRIMARY KEY,
  value        VARCHAR(128) NOT NULL UNIQUE
    CONSTRAINT task_name_min_len CHECK (length(value) >= 3)
);

INSERT INTO
  common.task_name (value)
VALUES
  ('Bathe'),
  ('Dishes'),
  ('Groceries'),
  ('Hoover'),
  ('Laundry'),
  ('Shopping'),
  ('Shower'),
  ('Trash'),
  ('Vacuum')
;

/*--------------------------------------------------------*\
| App Users                                                |
\*--------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS users.user
(
  -- Sequential user id
  user_id      BIGSERIAL PRIMARY KEY,

  -- User display name
  display_name VARCHAR(64) NOT NULL
    CONSTRAINT user_display_name_min_len CHECK (length(display_name) >= 3),

  -- Twofish encrypted user email
  email        BYTEA       NOT NULL UNIQUE,

  -- Sha256 hashed user password
  password     BYTEA       NOT NULL,

  -- user creation date
  created      TIMESTAMPTZ NOT NULL DEFAULT now()
);

/*--------------------------------------------------------*\
| User Password Reset Requests                             |
|                                                          |
| Holds time-sensitive entries for user password reset     |
| requests.                                                |
\*--------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS users.pw_resets
(
  -- Unique token assigned to each user password reset
  -- request.  Will be used in conjunction with the user's
  -- email address to help ensure baddies won't take over
  -- another user's password reset.
  token   CHAR(64)    NOT NULL UNIQUE,

  -- ID of the user that requested a password reset email.
  user_id BIGINT      NOT NULL
    REFERENCES users.user (user_id) ON DELETE CASCADE,

  -- Timestamp the request was created.
  created TIMESTAMPTZ NOT NULL DEFAULT now()
);

/*--------------------------------------------------------*\
| User Devices                                             |
|                                                          |
| Records the mobile devices from which a user has used    |
| the app along with whether or not that device is trusted |
| and may skip the user auth process.                      |
|                                                          |
| When set to "trust", a device will be issued a 64 digit  |
| token value.  That value in combination with the user    |
| email and the device ID will be used to validate that    |
| the auto-auth request is allowed                         |
\*--------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS users.device
(
  -- ID of the user the device belongs to
  user_id   BIGINT      NOT NULL
    REFERENCES users.user (user_id) ON DELETE CASCADE,

  -- Hardware ID of the device itself
  device_id VARCHAR(64) NOT NULL UNIQUE,

  -- Auto auth token.  Generated and sent to the device to
  -- enable that device to skip password authentication.
  auto_auth CHAR(64)
);

/*--------------------------------------------------------*\
| Task Definitions                                         |
|                                                          |
| Details about individual tasks.                          |
|                                                          |
| The task table uses a soft delete.  Tasks that are       |
| marked as deleted will be cleaned up after a set period  |
| of time.                                                 |
\*--------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS tasks.task
(
  -- Sequential task ID
  task_id          BIGSERIAL PRIMARY KEY,

  -- ID of the user that created the task.
  creator_id       BIGINT      NOT NULL
    REFERENCES users."user" (user_id) ON DELETE RESTRICT,

  -- ID of the name for this task in the common.task_name
  -- table.
  task_name_id     BIGINT      NOT NULL
    REFERENCES common.task_name (task_name_id) ON DELETE RESTRICT,

  -- Optional text describing the task.
  -- Capped at 1024 characters.
  task_description VARCHAR(1024),

  -- Timestamp for the creation of this task.
  created          TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Timestamp for the last modification of this task.
  updated          TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Optional timestamp for the deletion of this task.
  -- The presence of this value signifies that a task has
  -- been deleted.
  deleted          TIMESTAMPTZ
);

/*--------------------------------------------------------*\
| Task Step Definitions                                    |
|                                                          |
| Details about the individual steps under a task.         |
|                                                          |
| The step table uses a soft delete.  Steps that are       |
| marked as deleted will be cleaned up after a set period  |
| of time.                                                 |
\*--------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS tasks.step
(
  -- Sequential ID of the step.
  step_id     BIGSERIAL PRIMARY KEY,

  -- ID of the task a step belongs to.
  task_id     BIGINT        NOT NULL
    REFERENCES tasks.task (task_id) ON DELETE CASCADE,

  -- Description of the individual step.
  -- Must be 3 >= length >= 1024
  description VARCHAR(1024) NOT NULL
    CONSTRAINT step_desc_min_len CHECK (length(description) >= 3),

  -- Ordering indicator for this step in the task.
  position    INT2          NOT NULL,

  -- ID of the user that created this step.
  creator_id  BIGINT        NOT NULL
    REFERENCES users.user (user_id) ON DELETE RESTRICT,

  -- Timestamp for the creation of this step.
  created     TIMESTAMPTZ   NOT NULL DEFAULT now(),

  -- Timestamp for the last modification of this step.
  updated     TIMESTAMPTZ   NOT NULL DEFAULT now(),

  -- Optional timestamp for the deletion of this step.
  --
  -- The absence/presence of this value signifies whether a
  -- step has been deleted.
  deleted     TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS joins.user_to_task
(
  join_id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL
    REFERENCES users."user" (user_id) ON DELETE CASCADE,
  task_id BIGINT NOT NULL
    REFERENCES tasks.task (task_id) ON DELETE CASCADE
);

ALTER TABLE joins.user_to_task
  ADD CONSTRAINT jutt_unique
    UNIQUE (user_id, task_id);

CREATE TABLE IF NOT EXISTS logs.task_log
(
  join_id  BIGINT      NOT NULL REFERENCES joins.user_to_task (join_id),
  started  TIMESTAMPTZ NOT NULL DEFAULT now(),
  finished TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS logs.step_log
(
  join_id  BIGINT      NOT NULL REFERENCES joins.user_to_task (join_id),
  step_id  BIGINT      NOT NULL REFERENCES tasks.step (step_id),
  started  TIMESTAMPTZ NOT NULL DEFAULT now(),
  finished TIMESTAMPTZ
);