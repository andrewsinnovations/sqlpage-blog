SELECT
    'dynamic' as component,
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Configuration')) AS properties;

UPDATE
    settings
SET
    setting_value = $blog_name
WHERE
    setting_name = 'blog_name'
    and sqlpage.request_method() = 'POST';

UPDATE
    settings
SET
    setting_value = $post_routes
WHERE
    setting_name = 'post_routes'
    and sqlpage.request_method() = 'POST';

SELECT
    'alert' as component
    , 'Blog settings updated.' as title
    , 'blue' as color
    , 'check' as icon
    , true as dismissible
where
    sqlpage.request_method() = 'POST'
    and sqlpage.request_method() = 'POST';

SELECT
    'form' as component
    , 'Save Settings' as validate
    , 'post' as method;

SELECT
    'Blog Name' as label
    , 'blog_name' as name
    , setting_value as value
    , true as required
FROM
    settings
WHERE
    setting_name = 'blog_name';

SELECT
    'select' as type
    , 'Post Routes' as label
    , 'post_routes' as name
    , json('[
        {
            "label":"/YYYY/MM/DD/slug"
            ,"value":"ymd_slug"
            '|| case when setting_value = 'ymd_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/YYYY/MM/slug"
            ,"value":"ym_slug"
            '|| case when setting_value = 'ym_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/YYYY/slug"
            ,"value":"y_slug"
            '|| case when setting_value = 'y_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/YYYYMMDD/slug"
            ,"value":"date_slug"
            '|| case when setting_value = 'date_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/slug"
            ,"value":"slug"
            '|| case when setting_value = 'slug' then ', "selected": true' else '' end || '
        }
    ]') as options
FROM
    settings
WHERE
    setting_name = 'post_routes';