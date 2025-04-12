SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,
   sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Templates')) AS properties;

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Templates' as title
    , '/admin/templates' as link
    , true as active;

SELECT
    'alert' as component
    , 'blue' as color
    , 'Post deleted successfully.' as title
WHERE
    $deleted = 1;

SELECT
    'button' as component
    , 'mt-3' as class;

select 
    'Create New Template' as title
    , 'green' as color
    , 'edit' as link
    , 'plus' as icon;

SELECT
    'table' as component
    , 'template' as markdown
    , true as sort
    , 'No templates have been created yet.' as empty_description;

SELECT
    '[' || case when post_default = true then '(Post Default) ' else '' end ||  case when trim(name) != '' then name else 'No title set' end || '](edit?id=' || id || ')' as Template
FROM 
    template
order BY
    lower(name);