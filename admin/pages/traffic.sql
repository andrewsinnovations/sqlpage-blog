SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Edit Post', 'additional_javascript', '["/admin/posts/edit_post"]')) AS properties;

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Pages' as title
    , '/admin/pages' as link;

select 
    'New Post' as title
    , true as active
WHERE
    $id is null;

select 
    title as title
    , true as active
FROM
    posts
WHERE
    id = $id::int
    AND $id is not null;

select 
    'dynamic' as component
    , sqlpage.run_sql('admin/pages/.tabs.sql') AS properties;

SELECT
    'chart' as component, 
    'blue' as color,
    true as time,
    'Views' as title
WHERE
    $id is not null;

SELECT
    created_at::date as x
    , count(*) as y
FROM
    traffic
WHERE
    post_id = $id::int
group BY
    created_at::date;

SELECT
    'table' as component
WHERE
    $id is not null;

SELECT
    created_at::date as "Date"
    , count(*) as "Views"
FROM
    traffic
WHERE
    post_id = $id::int
group BY
    created_at::date
order BY
    created_at::date desc;
