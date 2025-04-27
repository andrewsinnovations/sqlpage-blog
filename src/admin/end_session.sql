delete from session where session_id = sqlpage.cookie('sid');

SELECT 
    'cookie' as component,
    'sid' as name,
    TRUE as remove;

SELECT
    'redirect' as component
    , '/admin/index' as link;
