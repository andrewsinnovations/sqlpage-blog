SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



UPDATE template
SET
    content = $template,
    name = $name,
    updated_at = current_timestamp
WHERE
    $id IS NOT NULL
    AND id = $id::int
;



INSERT INTO
    template (name, content, post_default)
SELECT
    $name,
    $template,
    FALSE
WHERE
    $id IS NULL
;



SET
    id = (
        SELECT
            CASE
                WHEN $id IS NULL
                OR $id = '' THEN currval('template_id_seq')
                ELSE cast($id AS integer)
            END
    )
INSERT INTO
    template_history (template_id, created_at, content, name)
VALUES
    ($id::int, current_timestamp, $template, $name)
;



-- set post default if supplied
UPDATE template
SET
    post_default = CASE
        WHEN id = $id::int THEN TRUE
        ELSE FALSE
    END
WHERE
    $default_for_posts IS NOT NULL
;



-- save the template into sqlpage template system
DELETE FROM sqlpage_files
WHERE
    path = 'sqlpage/templates/template_' || $id || '.handlebars'
;



INSERT INTO
    sqlpage_files (path, contents, created_at, last_modified)
VALUES
    (
        'sqlpage/templates/template_' || $id || '.handlebars',
        convert_to($template, 'UTF8'),
        current_timestamp,
        current_timestamp
    )
;



SELECT
    'redirect' AS component,
    'edit?id=' || $id || '&saved=1' AS link
;
