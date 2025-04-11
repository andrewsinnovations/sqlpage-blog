create table template_history (
    id integer primary key,
    name text not null,
    content text not null,
    template_id integer not null,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp
);

insert into template_history (name, content, template_id)
SELECT
    name,
    content,
    id
FROM
    template;