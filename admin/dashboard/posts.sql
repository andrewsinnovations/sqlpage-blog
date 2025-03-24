SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/shell.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/tabs_dashboard.sql') AS properties;

SELECT
    'button' as component;

select 
    'Create New Post' as title
    , 'green' as color
    , 'post?id=new&type=post' as link
    , 'plus' as icon;

SELECT
    'table' as component
    , 'title' as markdown
    , 'url' as markdown
    , true as sort
    , 'No posts have been created yet.' as empty_description;   

SELECT
    '[' || case when trim(title) != '' then title else 'No title set' end || '](post?id=' || id || ')' as title 
    , case when posts.published = true then '[' || replace(sqlpage_files.path, '.sql', '') || '](/' || replace(sqlpage_files.path, '.sql', '')  || ')'
        else 'Not published' 
    end as url
    , posts.last_modified as `Last Updated`
    , case when posts.published = true then 'Yes' else 'No' end as Published
FROM
    posts
    left join sqlpage_files on posts.id = sqlpage_files.post_id
WHERE
    post_type = 'post'
order BY
    posts.last_modified desc;
