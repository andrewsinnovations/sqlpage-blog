select 'tab' as component, 'mt-3' as class;

select 
    'Edit Post' as title
    , 'post?id=' || $id as link
    , case when sqlpage.path() = '/admin/posts/post' then true else false end as active;

select 
    'Traffic' as title
    , 'traffic?id=' || $id as link
    , case when sqlpage.path() in ('/admin/posts/traffic') then true else false end as active;