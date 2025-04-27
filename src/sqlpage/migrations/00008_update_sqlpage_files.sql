drop table sqlpage_files;

CREATE TABLE sqlpage_files(
  path text NOT NULL PRIMARY KEY,
  contents bytea not null,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  post_id integer
);