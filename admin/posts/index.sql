SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Posts')) AS properties;

SELECT
    'alert' as component
    , 'blue' as color
    , 'Post deleted successfully.' as title
WHERE
    $deleted = '1';

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Posts' as title
    , '/admin/posts' as link
    , true as active;

SELECT
    'button' as component
    , 'mt-3' as class;

select 
    'Create New Post' as title
    , 'green' as color
    , 'post?type=post' as link
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
    , posts.last_modified as "Last Updated"
    , case when posts.published = true then 'Yes' else 'No' end as Published
    , coalesce(traffic_data.traffic, 0) as Views
FROM
    posts
    left join sqlpage_files on posts.id = sqlpage_files.post_id
    left join (
        select post_id, count(*) as traffic from traffic group by post_id
    ) traffic_data
        on posts.id = traffic_data.post_id
    left join (
        select post_id, count(*) as traffic from traffic where created_at >= now()::date + interval '-1 day' group by post_id
    ) traffic_data_today
        on posts.id = traffic_data_today.post_id
    left join (
        select post_id, count(*) as traffic from traffic where created_at >= now()::date + interval '-30 day' group by post_id
    ) traffic_data_last_30
        on posts.id = traffic_data_last_30.post_id
WHERE
    post_type = 'post'
order BY
    posts.last_modified desc;