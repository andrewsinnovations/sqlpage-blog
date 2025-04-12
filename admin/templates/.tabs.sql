select 'tab' as component, 'mt-3' as class;

select 
    'Edit Template' as title
    , 'edit?id=' || $id as link
    , case when sqlpage.path() = '/admin/templates/edit' then true else false end as active;

select 
    'View Revision History' as title
    , 'history?id=' || $id as link
    , case when sqlpage.path() in ('/admin/templates/history', '/admin/templates/revision') then true else false end as active;