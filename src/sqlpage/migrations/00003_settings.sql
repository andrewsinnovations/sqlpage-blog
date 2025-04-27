create table settings(
    id serial primary key,
    setting_name text not null,
    setting_value text,
    created_at timestamp not null default current_timestamp,
    last_modified timestamp not null default current_timestamp
)