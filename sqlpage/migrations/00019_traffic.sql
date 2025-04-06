create table if not exists traffic (
    post_id integer,
    url text not null,
    created_at timestamp not null default current_timestamp,
    foreign key (post_id) references posts(id)
);