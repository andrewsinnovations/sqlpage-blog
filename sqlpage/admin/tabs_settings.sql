SELECT
    'tab' as component;

SELECT
    'Blog Settings' as title
    , 'settings' as link
    , case when sqlpage.path() = '/admin/settings' then true else false end as active;

SELECT
    'Templates' as title
    , 'templates' as link
    , case when sqlpage.path() = '/admin/templates' then true else false end as active;