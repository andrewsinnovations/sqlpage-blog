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
            json(
                '["https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs/loader.min.js"]'
            ),
            'additional_javascript_module',
            json('["/admin/templates/edit_script"]')
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
    'Templates' AS title,
    '/admin/templates' AS link
;



SELECT
    'New Template' AS title,
    TRUE AS active
WHERE
    $id IS NULL
;



SELECT
    name AS title,
    TRUE AS active
FROM
    template
WHERE
    id = $id::int
;



SELECT
    'alert' AS component,
    'blue' AS color,
    'Template saved successfully.' AS title
WHERE
    $saved IS NOT NULL
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/templates/.tabs.sql') AS properties
;



SELECT
    'form_with_html' AS component,
    'Save Template' AS validate,
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
    'name' AS name,
    'Name' AS label,
    TRUE AS required
WHERE
    $id IS NULL
;



SELECT
    'name' AS name,
    'Name' AS label,
    TRUE AS required,
    name AS value
FROM
    template
WHERE
    id = $id::int
;



SELECT
    'html' AS type,
    '<div id="template-content" style="width:100%;border:1px solid #aaa;"></div><div class="m-3"></div>' AS html
;



SELECT
    'checkbox' AS type,
    'Default For Posts' AS label,
    'default_for_posts' AS name
WHERE
    $id IS NULL
;



SELECT
    'checkbox' AS type,
    'Default For Posts' AS label,
    'default_for_posts' AS name,
    CASE
        WHEN post_default = TRUE THEN TRUE
        ELSE FALSE
    END AS checked
FROM
    template
WHERE
    id = $id::int
;



SELECT
    'html' AS component,
    '<div class="ps-4"><p>Below are the binding values for supplied for your templates:</p><ul>
  <li><code>post</code> - An object containing information about the post.
  <ul>
    <li><code>post_date</code> - The publication date of the post.</li>
    <li><code>title</code> - The title of the post.</li>
    <li><code>slug_path</code> - The URL from the root of the post.</li>
    <li><code>post_date_last_modified</code> - The date of last modification (not publication) of the post.</li>
    <li><code>content</code> - The HTML content of the post.</li>
  </ul>
  </li>
  <li><code>posts</code> - An array of all published posts, including the current post, sorted by publication date descending, using the schema of the <code>post</code> object above.</li>
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