SELECT
    'redirect' as component
    , '/admin/install' as link
WHERE
    not exists (select * from login);

insert into traffic (url)
values ('/');

select 'shell-empty' as component;

set posts = (
    SELECT
        json_group_array(
            JSON(value)
        ) 
    from 
        json_each(
            json_extract(
                JSON(
                    sqlpage.run_sql('.post_data.sql')
                )
            , '$[0].posts'
        )
    )
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


SELECT
    'template_' || (select id from template where name = 'Homepage') as component
    , json($posts) as posts
    , json($settings) as settings;
