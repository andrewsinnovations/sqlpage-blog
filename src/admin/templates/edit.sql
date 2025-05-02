SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql'
        , json_build_object(
            'shell_title', 'Edit Template',
            'additional_javascript', JSON('["https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs/loader.min.js"]'),
            'additional_javascript_module', JSON('["/admin/templates/edit_script"]')
        )
    ) AS properties;

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Templates' as title
    , '/admin/templates' as link;

SELECT
    'New Template' as title
    , true as active
WHERE
    $id is null;

SELECT
    name as title
    , true as active
FROM
    template
WHERE
    id = $id::int;

SELECT
    'alert' as component
    , 'blue' as color
    , 'Template saved successfully.' as title
WHERE
    $saved is not null;

select 'dynamic' as component
    , sqlpage.run_sql('admin/templates/.tabs.sql') AS properties;

SELECT
    'form_with_html' as component
    , 'Save Template' as validate
    , 'template-form' as id
    , 'post' as method
    , 'save' as action;

SELECT
    'hidden' as type
    , 'id' as name
    , $id as value
WHERE
    $id is not null;

SELECT
    'name' as name
    , 'Name' as label
    , true as required
WHERE
    $id is null;

SELECT
    'name' as name
    , 'Name' as label
    , true as required
    , name as value
FROM
    template
WHERE
     id = $id::int;

SELECT
    'html' as type
    , '<div id="template-content" style="width:100%;border:1px solid #aaa;"></div><div class="m-3"></div>' as html;

SELECT
    'checkbox' as type
    , 'Default For Posts' as label
    , 'default_for_posts' as name
WHERE
    $id is null;

SELECT
    'checkbox' as type
    , 'Default For Posts' as label
    , 'default_for_posts' as name
    , case when post_default = true then true else false end as checked
FROM
    template
WHERE
    id = $id::int;

SELECT
    'html' as component,
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
' as html;