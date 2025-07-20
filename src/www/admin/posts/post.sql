SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object(
            'shell_title',
            'Edit Post',
            'additional_javascript',
            '["https://cdn.jsdelivr.net/npm/lemonadejs@5/dist/lemonade.min.js", "/admin/posts/edit_post"]'
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
    'Posts' AS title,
    '/admin/posts' AS link
;



SELECT
    'New Post' AS title,
    TRUE AS active
WHERE
    $id IS NULL
;



SELECT
    title AS title,
    TRUE AS active
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/posts/.tabs.sql') AS properties
;



SELECT
    'alert' AS component,
    'blue' AS color,
    'Your post was saved!' AS title,
    CASE
        WHEN published_date IS NOT NULL THEN '/' || replace(sqlpage_files.path, '.sql', '')
        ELSE NULL
    END AS link,
    'Click here to view your post' AS link_text,
    CASE
        WHEN published_date IS NULL THEN 'It has not yet been published.'
        ELSE NULL
    END AS description
FROM
    posts
    LEFT JOIN sqlpage_files ON posts.id = sqlpage_files.post_id
WHERE
    $saved = '1'
    AND id = $id::int
;



SELECT
    'form_with_html' AS component,
    'Save' AS validate,
    'post-form' AS id,
    'post' AS method,
    'save_post' AS action
;



SELECT
    'hidden' AS type,
    'id' AS name,
    $id AS value
WHERE
    $id IS NOT NULL
;



SELECT
    'hidden' AS type,
    'type' AS name,
    'post' AS value
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
    AND $id IS NOT NULL
;



SELECT
    'Slug' AS label,
    slug AS value,
    TRUE AS disabled
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
    (
        SELECT
            id
        FROM
            template
        WHERE
            post_default = TRUE
    ) AS value,
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
;



SELECT
    'html' AS type,
    '<div id="content" placeholder="Your new content goes here!"></div>' AS html
WHERE
    $id IS NULL
;



SELECT
    'html' AS type,
    '<div id="content">' || content || '</div>' AS html
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;



SELECT
    'html' AS type,
    '<button type="button" class="btn btn-secondary mt-3" id="revise_post">Revise With AI</button>' AS html
;



SELECT
    'html' AS type,
    '<hr/>' AS html
;



SELECT
    'Publish Immediately' AS label,
    'checkbox' AS type,
    'published' AS name
WHERE
    $id IS NULL
;



SELECT
    'Published' AS label,
    'checkbox' AS type,
    'published' AS name,
    CASE
        WHEN published_date IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS checked,
    'published' AS id
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;



SELECT
    'Published Date' AS label,
    'datetime-local' AS type,
    'published_date' AS name,
    'published_date' AS id,
    CASE
        WHEN published_date IS NOT NULL THEN replace(
            to_char(
                published_date at time zone timezone,
                'YYYY-MM-DD HH24:MI'
            ),
            ' ',
            'T'
        )
        ELSE NULL
    END AS value
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;



SELECT
    'select' AS type,
    'Timezone' AS label,
    'timezone' AS name,
    TRUE AS required,
    CASE
        WHEN timezone IS NULL THEN (
            SELECT
                setting_value
            FROM
                settings
            WHERE
                setting_name = 'default_timezone'
        )
        ELSE timezone
    END AS value,
    'timezone' AS id,
    (
        SELECT
            json_agg(options)
        FROM
            (
                SELECT
                    json_build_object('label', name, 'value', name) AS options
                FROM
                    pg_timezone_names
                ORDER BY
                    name
            ) options
    ) AS options
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;