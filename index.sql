SELECT
    'redirect' as component
    , '/admin/install' as link
WHERE
    not exists (select * from login);

insert into traffic (url)
values ('/');

select 'shell-empty' as component;

set posts = (
    select (sqlpage.run_sql('.post_data.sql', json_build_object('all_posts', 'true'))::jsonb) -> 0 -> 'posts'
);

set settings = (
    select (sqlpage.run_sql('.settings_data.sql')::jsonb) -> 0 -> 'settings'
);


SELECT
    'template_' || (select id from template where name = 'Homepage') as component
    , json($posts) as posts
    , json($settings) as settings;
