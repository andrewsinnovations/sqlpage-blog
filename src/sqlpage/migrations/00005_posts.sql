alter table sqlpage_files drop column blog_contents;

create table posts(
    id serial primary key,
    title text not null,
    content text not null,
    published_date timestamp not null default current_timestamp,
    slug text not null,
    created_at timestamp not null default current_timestamp,
    last_modified timestamp not null default current_timestamp
);

alter table sqlpage_files add column post_id integer references posts(id);