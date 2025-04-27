SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

select 'http_header' as component, 'text/javascript; charset=utf-8' as "Content-Type";
select 'shell-empty' as component;

select 'html' as component
, sqlpage.read_file_as_text('admin/pages/.edit_settings.js') as html;