-- GET Method: Show login form
SELECT
    'redirect' as component
    , '/admin/install' as link
WHERE
    not exists (select * from login);

select 'status_code' as component
    , 404 as status;  

select 'shell-empty' as component;

select 'html' as component
    , setting_value as html
FROM
    settings
WHERE
    setting_name = 'before_post';

SELECT
    'text' as component
    , '404 - Page Not Found' as title
    , 'This page was not found.' as contents;

select 'html' as component
    , setting_value as html
FROM
    settings
WHERE
    setting_name = 'after_post';
