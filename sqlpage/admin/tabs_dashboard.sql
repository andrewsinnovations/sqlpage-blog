SELECT
    'tab' as component;

SELECT
    'Posts' as title
    , 'posts' as link
    , case when $type = 'post' or sqlpage.path() in ('/admin/dashboard/posts') then true else false end as active;

SELECT
    'Files' as title
    , 'files' as link
    , case when $type = 'file' or sqlpage.path() in ('/admin/dashboard/files') then true else false end as active;
