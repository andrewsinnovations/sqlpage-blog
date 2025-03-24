create table session(
    id integer primary key,
    session_id text not null,
    login_id integer not null,
    expires_at timestamp not null,
    created_at timestamp not null default current_timestamp,
    last_modified timestamp not null default current_timestamp
);