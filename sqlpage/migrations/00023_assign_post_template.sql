alter table posts add template_id integer references template(id);

update posts set template_id = (
    select id from template where post_default = true
);