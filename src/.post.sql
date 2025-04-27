set search_path = substr(lower(sqlpage.path()) || '.sql', 2);

set post_id = (
    select post_id from sqlpage_files where lower(path) = $search_path
)

SELECT
    'dynamic' as component
    , sqlpage.run_sql('404.sql') as properties
WHERE
    $post_id is null;

set template_id = (
    select template_id from posts where id = $post_id::int
);

select 
    'shell-empty' as component
WHERE
    $post_id is not null;

insert into traffic 
(
    post_id
    , url
) 
select 
    $post_id::int
    , sqlpage.path()
WHERE
    $post_id is not null;

set post = (
    select (sqlpage.run_sql('.post_data.sql')::jsonb) -> 0 -> 'posts' -> 0
);

set posts = (
    select (sqlpage.run_sql('.post_data.sql', json_build_object('all_posts', 'true'))::jsonb) -> 0 -> 'posts'
);

set settings = (
    select (sqlpage.run_sql('.settings_data.sql')::jsonb) -> 0 -> 'settings'
);

select 
    'template_' || $template_id as component
    , JSON($post) as post
    , JSON($posts) as posts
    , json($settings) as settings
WHERE
    $post_id is not null;