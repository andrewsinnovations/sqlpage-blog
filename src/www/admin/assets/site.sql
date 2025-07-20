SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'http_header' AS component,
    'text/css; charset=utf-8' AS "Content-Type"
;



SELECT
    'shell-empty' AS component
;



SELECT
    'html' AS component,
    sqlpage.read_file_as_text ('admin/assets/.site.css') AS html
;