SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

select 'shell-empty' as component;

select 'html' as component, content as html from template where id = $id;