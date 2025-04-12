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
    select template_id from posts where id = $post_id
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
    $post_id
    , sqlpage.path()
WHERE
    $post_id is not null;

set post = (
    select 
        json_extract(
            coalesce(sqlpage.run_sql(
                '.post_data.sql'
            ), '{}'),
        '$[0].posts[0]'
        ) as post_data
        where $post_id is not null
)

set settings = (
    select
    json_extract(
        JSON(
            sqlpage.run_sql('.settings_data.sql')
        )
        , '$[0].settings'
    )
);  

select 
    'template_' || $template_id as component
    , JSON($post) as post
    , json($settings) as settings
WHERE
    $post_id is not null;