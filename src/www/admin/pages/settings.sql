SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_build_object(
            'shell_title',
            'Edit Page Settings',
            'additional_javascript',
            json('["/admin/pages/edit_settings"]')
        )
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
    'Pages' AS title,
    '/admin/pages' AS link
;



SELECT
    'New Page' AS title,
    TRUE AS active
WHERE
    $id IS NULL
;



SELECT
    title,
    TRUE AS active
FROM
    posts
WHERE
    id = $id::int
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/pages/.tabs.sql') AS properties
WHERE
    $id IS NOT NULL
;



SELECT
    'alert' AS component,
    'blue' AS color,
    'Page saved successfully.' AS title
WHERE
    $saved IS NOT NULL
;



SELECT
    'alert' AS component,
    'red' AS color,
    'Invalid path. Cannot set a path under /admin/ or /sqlpage/ or /uploads/' AS title
WHERE
    $invalid_path IS NOT NULL
;



SELECT
    'alert' AS component,
    'red' AS color,
    'The supplied path already exists.' AS title
WHERE
    $path_exists IS NOT NULL
;



SELECT
    'form_with_html' AS component,
    'Save Page' AS validate,
    'template-form' AS id,
    'post' AS method,
    'save_settings' AS action
;



SELECT
    'hidden' AS type,
    'id' AS name,
    $id AS value
WHERE
    $id IS NOT NULL
;



SELECT
    'select' AS type,
    'type' AS name,
    'Page Type' AS label,
    TRUE AS required,
    'page_type' AS id,
    '[{"value": "page-html", "label": "HTML Page"}, {"value": "page-templated", "label": "Templated Page"}]' AS options
WHERE
    $id IS NULL
;



SELECT
    'select' AS type,
    'type' AS name,
    'Page Type' AS label,
    post_type AS value,
    TRUE AS required,
    'page_type' AS id,
    '[{"value": "page-html", "label": "HTML Page"}, {"value": "page-templated", "label": "Templated Page"}]' AS options
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;



SELECT
    'select' AS type,
    'Template' AS label,
    'template_id' AS name,
    'template_id' AS id,
    (
        SELECT
            json_agg(value)
        FROM
            (
                SELECT
                    json_build_object('value', id, 'label', name) AS value
                FROM
                    template
                ORDER BY
                    name
            )
    ) AS options
WHERE
    $id IS NULL
;



SELECT
    'select' AS type,
    'Template' AS label,
    'template_id' AS name,
    'template_id' AS id,
    template_id AS value,
    (
        SELECT
            json_agg(value)
        FROM
            (
                SELECT
                    json_build_object('value', id, 'label', name) AS value
                FROM
                    template
                ORDER BY
                    name
            )
    ) AS options
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;



SELECT
    'title' AS name,
    'Title' AS label,
    TRUE AS required
WHERE
    $id IS NULL
;



SELECT
    'title' AS name,
    'Title' AS label,
    TRUE AS required,
    title AS value
FROM
    posts
WHERE
    id = $id::int
;



SELECT
    'path' AS name,
    'Path' AS label,
    TRUE AS required
WHERE
    $id IS NULL
;



SELECT
    'path' AS name,
    'Path' AS label,
    TRUE AS required,
    slug AS value
FROM
    posts
WHERE
    id = $id::int
;
