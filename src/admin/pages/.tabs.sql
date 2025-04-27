SELECT 'tab' as component;
SELECT 'Page Settings' as title, 'settings?id=' || $id as link, 'settings' as name, case when sqlpage.path() = '/admin/pages/settings' then true else false end as active;
SELECT 'Edit Page' as title, 'edit?id=' || $id as link, 'contents' as name, case when sqlpage.path() = '/admin/pages/edit' then true else false end as active;
SELECT 'Traffic' as title, 'traffic?id=' || $id as link, 'contents' as name, case when sqlpage.path() = '/admin/pages/traffic' then true else false end as active;