SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql') as properties;

select 'dynamic' as component
    , sqlpage.run_sql('admin/settings/template/.tabs.sql') AS properties;

select 'breadcrumb' as component;

select 
    template.name as title
    , 'history?id=' || template.id as link
FROM
    template_history
    inner join template
        on template.id = template_history.template_id
WHERE
    template_history.id = $id;

select 
    'Revision ' || template_history.created_at as title
    , true as active
FROM                        
    template_history
WHERE
    template_history.id = $id;
            
select 'divider' as component;  
select 'button' as component, 'right'as align;

select 'Restore This Version' as title
    , 'green' as color;  

SELECT
    'text' as component
    , '```
' || content  || '
```'as contents_md
FROM
    template_history
WHERE
    id = $id;   