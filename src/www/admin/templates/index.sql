SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Templates')
    ) AS properties
;



SELECT
    'breadcrumb' AS component
;



SELECT
    'Home' AS title,
    '/admin/dashboard' AS link
;



SELECT
    'Templates' AS title,
    '/admin/templates' AS link,
    TRUE AS active
;



SELECT
    'button' AS component,
    'mt-3' AS class
;



SELECT
    'Create New Template' AS title,
    'green' AS color,
    'edit' AS link,
    'plus' AS icon
;



SELECT
    'table' AS component,
    'template' AS markdown,
    TRUE AS sort,
    'No templates have been created yet.' AS empty_description
;



SELECT
    '[' || CASE
        WHEN post_default = TRUE THEN '(Post Default) '
        ELSE ''
    END || CASE
        WHEN trim(name) != '' THEN name
        ELSE 'No title set'
    END || '](edit?id=' || id || ')' AS template
FROM
    template
ORDER BY
    lower(name)
;