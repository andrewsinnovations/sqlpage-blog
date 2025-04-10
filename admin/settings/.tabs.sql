SELECT
    'tab' as component;

SELECT
    'Blog Settings' as title
    , 'config' as link
    , case when sqlpage.path() = '/admin/settings/config' then true else false end as active;

SELECT
    'Templates' as title
    , 'templates' as link
    , case when sqlpage.path() = '/admin/settings/templates' then true else false end as active;