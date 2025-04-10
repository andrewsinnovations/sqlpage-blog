SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/settings/.tabs.sql') AS properties;

delete from sqlpage_files
where path = 'sqlpage/templates/home.handlebars'
    and sqlpage.request_method() = 'POST';

delete from sqlpage_files
where path = 'sqlpage/templates/post.handlebars'
    and sqlpage.request_method() = 'POST';

insert into sqlpage_files
(
    path
    , contents
    , last_modified
    , created_at
)
select
    'sqlpage/templates/home.handlebars'
    , :homepage_html
    , CURRENT_TIMESTAMP
    , CURRENT_TIMESTAMP
where
    sqlpage.request_method() = 'POST';

insert into sqlpage_files
(
    path
    , contents
    , last_modified
    , created_at
)
select
    'sqlpage/templates/post.handlebars'
    , :post_html
    , CURRENT_TIMESTAMP
    , CURRENT_TIMESTAMP
where
    sqlpage.request_method() = 'POST';

select 
    'alert' as component
    , 'Settings Saved' as title
    , 'blue' as color
where
    sqlpage.request_method() = 'POST';

set homepage_html = (
    select contents from sqlpage_files 
    where path = 'sqlpage/templates/home.handlebars'
);

set post_html = (
    select contents from sqlpage_files 
    where path = 'sqlpage/templates/post.handlebars'
);

SELECT
    'form' as component
    , 'post' as method;

SELECT
    'textarea' as type
    , 'Homepage HTML' as label
    , 'homepage_html' as name
    , $homepage_html as value;

SELECT
    'textarea' as type
    , 'Post HTML' as label
    , 'post_html' as name
    , $post_html as value;