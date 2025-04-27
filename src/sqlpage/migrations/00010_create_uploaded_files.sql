create table uploaded_files (
    id serial primary key,
    path text not null,
    contents text not null,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp
)