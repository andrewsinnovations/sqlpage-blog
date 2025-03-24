SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/shell.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/tabs_settings.sql') AS properties;

update settings
set 
    setting_value = :before_post
where
    setting_name = 'before_post'
    and sqlpage.request_method() = 'POST';


update settings
set 
    setting_value = :after_post
where
    setting_name = 'after_post'
    and sqlpage.request_method() = 'POST';

select 
    'alert' as component
    , 'Settings Saved' as title
    , 'blue' as color
where
    sqlpage.request_method() = 'POST';

set before_post = (
    select 
        setting_value
    from
        settings
    where
        setting_name = 'before_post'
);

set after_post = (
    select 
        setting_value
    from
        settings
    where
        setting_name = 'after_post'
);

SELECT
    'form' as component
    , 'post' as method;

SELECT
    'textarea' as type
    , 'HTML Before Post' as label
    , 'before_post' as name
    , $before_post as value;

SELECT
    'textarea' as type
    , 'HTML After Post' as label
    , 'after_post' as name
    , $after_post as value;
    