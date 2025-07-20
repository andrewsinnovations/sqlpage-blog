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
            'Edit Template',
            'additional_javascript',
            CASE
                WHEN post_type = 'page-html' THEN json(
                    '["https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs/loader.min.js"]'
                )
                ELSE json('["/admin/pages/edit_script_templated"]')
            END,
            'additional_javascript_module',
            CASE
                WHEN post_type = 'page-html' THEN json('["/admin/pages/edit_script"]')
                ELSE json('[]')
            END
        )
    ) AS properties
FROM
    posts
WHERE
    id = $id::int
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
;



SELECT
    'alert' AS component,
    'blue' AS color,
    'Page saved successfully.' AS title
WHERE
    $saved IS NOT NULL
;



SELECT
    'form_with_html' AS component,
    'Save Page' AS validate,
    'template-form' AS id,
    'post' AS method,
    'save' AS action
;



SELECT
    'hidden' AS type,
    'id' AS name,
    $id AS value
WHERE
    $id IS NOT NULL
;



SELECT
    'html' AS type,
    '<div id="html-content" style="width:100%;border:1px solid #aaa;"></div><div class="m-3"></div>' AS html
FROM
    posts
WHERE
    id = $id::int
    AND post_type = 'page-html'
;



SELECT
    'html' AS type,
    '<div id="content" placeholder="Your new content goes here!">' || content || '</div>' AS html
FROM
    posts
WHERE
    id = $id::int
    AND post_type = 'page-templated'
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



SELECT
    'html' AS component,
    '<div class="ps-4"><p>Below are the binding values for supplied for your templates:</p><ul>
  <li><code>page</code> - An object containing information about the post.
  <ul>
    <li><code>post_date</code> - The publication date of the page.</li>
    <li><code>title</code> - The title of the page.</li>
    <li><code>slug_path</code> - The URL from the root of the page.</li>
    <li><code>post_date_last_modified</code> - The date of last modification (not publication) of the page.</li>
    <li><code>content</code> - The HTML content of the page.</li>
  </ul>
  </li>
  <li><code>posts</code> - An array of all published posts sorted by publication date descending, using the schema of the <code>post</code> object above.</li>
  <li><code>settings</code> - An object containing the site settings.
  <ul>
    <li><code>blog_name</code> - The name of the site.</li>
    <li><code>site_description</code> - The description of the site.</li>
    <li><code>default_timezone</code> - The configured timezone.</li>
  </ul>
  </li>
</ul></div>
' AS html
;