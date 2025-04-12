SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Template History')) as properties;

set template_id = (
    select template_id from template_history where id = $id
);

select 'dynamic' as component
    , sqlpage.run_sql('admin/templates/.tabs.sql', json_object('id', $template_id)) AS properties;

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

select 
    'button' as component, 'mt-2' as class;

-- show restore button but only if this is not the most recent revision
select 'Restore This Version' as title
    , 'green' as color
    , 'restore?id=' || $id as link
WHERE
    $id != (
        select 
            max(template_history.id) 
        from 
            template_history  
        where 
            template_history.template_id = (
                select template_id 
                from template_history
                where id = $id
            ) 
    )

SELECT
    'text' as component
    , '```
' || content  || '
```'as contents_md
FROM
    template_history
WHERE
    id = $id;   