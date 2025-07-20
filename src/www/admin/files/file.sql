SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.shell.sql') AS properties
;



SELECT
    'breadcrumb' AS component
;



SELECT
    'Home' AS title,
    '/admin/dashboard' AS link
;



SELECT
    'Files' AS title,
    '/admin/files' AS link
;



SELECT
    'Upload New File' AS title,
    TRUE AS active
;



SELECT
    'form' AS component,
    'Save' AS validate,
    'post-form' AS id,
    'post' AS method,
    'save_file' AS action
;



SELECT
    'hidden' AS type,
    'id' AS name,
    $id AS value
;



SELECT
    'file' AS type,
    'file' AS name,
    'File' AS label,
    TRUE AS required
WHERE
    $id = 'new'
;



SELECT
    'foldable' AS component
WHERE
    $id != 'new'
;



SELECT
    'Record Actions' AS title,
    '- [Delete Record](delete_post?id=' || $id || ')' AS description_md
WHERE
    $id != 'new'
;
