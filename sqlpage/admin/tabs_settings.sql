SELECT
    'tab' as component;

SELECT
    'Blog Settings' as title
    , 'settings' as link
    , case when sqlpage.path() = '/admin/settings' then true else false end as active;

SELECT
    'Homepage Templates' as title
    , 'home_templates' as link
    , case when sqlpage.path() = '/admin/home_templates' then true else false end as active;


SELECT
    'Post Templates' as title
    , 'post_templates' as link
    , case when sqlpage.path() = '/admin/post_templates' then true else false end as active;
