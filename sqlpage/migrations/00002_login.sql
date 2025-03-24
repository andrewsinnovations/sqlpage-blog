create table login (
    id integer primary key,
    username text not null,
    password_hash text not null,
    created_at timestamp not null default current_timestamp,
    last_modified timestamp not null default current_timestamp
);