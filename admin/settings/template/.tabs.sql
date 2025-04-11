select 'tab' as component;

select 
    'Edit Template' as title
    , 'edit?id=' || $id as link
    , case when sqlpage.path() = '/admin/settings/template/edit' then true else false end as active;

select 
    'View Revision History' as title
    , 'history?id=' || $id as link
    , case when sqlpage.path() in ('/admin/settings/template/history', '/admin/settings/template/revision') then true else false end as active;