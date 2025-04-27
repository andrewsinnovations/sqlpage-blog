select 'status_code' as component
    , 404 as status;  

insert into traffic 
(
    url
    , status_code
) 
select 
    sqlpage.path()
    , 404;

set post = (
    select json_build_object(
            'title', 'Page Not Found',
            'slug_path', '',
            'db_path', '',
            'post_date', '',
            'content', 'Sorry, the URL you are trying to access was not found.'
        ) as post_data
)

set settings = (
    select (sqlpage.run_sql('.settings_data.sql')::jsonb) -> 0 -> 'settings'
);

select 'shell-empty' as component;

select 
    'template_' || id as component
    , JSON($post) as post
    , json($settings) as settings
FROM
    template
WHERE
    post_default = true;