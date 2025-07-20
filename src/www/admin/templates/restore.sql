SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SET
    content = (
        SELECT
            content
        FROM
            template_history
        WHERE
            id = $id::int
    )
;



SET
    template_id = (
        SELECT
            template_id
        FROM
            template_history
        WHERE
            id = $id::int
    )
;



UPDATE template
SET
    content = $content
WHERE
    id = $template_id::int
;



INSERT INTO
    template_history (template_id, content, name, created_at)
SELECT
    template_id,
    content,
    name,
    current_timestamp
FROM
    template_history
WHERE
    id = $id::int
;



-- save the template into sqlpage template system
DELETE FROM sqlpage_files
WHERE
    path = 'sqlpage/templates/template_' || $template_id || '.handlebars'
;



INSERT INTO
    sqlpage_files (path, contents, created_at, last_modified)
SELECT
    'sqlpage/templates/template_' || $template_id || '.handlebars',
    convert_to($content, 'UTF8'),
    current_timestamp,
    current_timestamp
FROM
    template_history
WHERE
    id = $id::int
;



SELECT
    'redirect' AS component,
    'edit?id=' || template_id || '&saved=1' AS link
FROM
    template_history
WHERE
    id = $id::int
;
