create table settings(
    id integer primary key,
    setting_name text,
    setting_value text,
    created_at timestamp not null default current_timestamp,
    last_modified timestamp not null default current_timestamp
)