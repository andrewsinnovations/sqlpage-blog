SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Posts')) AS properties;

set date_format = (
    select coalesce(setting_value, 'MM/DD/YYYY')
    from settings
    where setting_name = 'dashboard_date_format'
);

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
    'Pages' as title
    , '/admin/pages' as link
    , true as active;

SELECT
    'button' as component
    , 'mt-3' as class;

select 
    'Create New Page' as title
    , 'green' as color
    , 'settings' as link
    , 'plus' as icon;

SELECT
    'table' as component
    , 'title' as markdown
    , 'url' as markdown
    , true as sort
    , 'No pages have been created yet.' as empty_description;   

SELECT
    '[' || case when trim(posts.title) != '' then posts.title else 'No title set' end || '](settings?id=' || posts.id || ')' as title 
    , case when posts.published_date is not null then slug else 'Not Published' end as url    
    , case when post_type = 'page-html' then 'HTML'
        when post_type = 'page-templated' then 'Templated'
        else post_type
    end as type
    , case when post_type = 'page-templated' then template.name else '' end as template
    , to_char(posts.last_modified at time zone timezone, $date_format)  as "Last Updated"
    , coalesce(traffic_data.traffic, 0) as Views
FROM
    posts
    left join template on posts.template_id = template.id
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
    post_type in ('page-html', 'page-templated')
order BY
    posts.last_modified desc;