create table sqlpage_files (
    id integer primary key,
    path text not null,
    content text not null,
    blog_contents text not null,
    created_at timestamp not null default current_timestamp,
    last_modified timestamp not null default current_timestamp
)