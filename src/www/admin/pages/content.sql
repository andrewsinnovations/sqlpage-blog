SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'shell-empty' AS component
;



SELECT
    'html' AS component,
    content AS html
FROM
    posts
WHERE
    id = $id::int
;