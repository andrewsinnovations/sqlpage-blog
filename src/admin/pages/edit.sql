SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql'
        , json_build_object(
            'shell_title', 'Edit Template',
            'additional_javascript', 
                case when post_type = 'page-html' then JSON('["https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs/loader.min.js"]')
                    else JSON('["/admin/pages/edit_script_templated"]')
                end,
            'additional_javascript_module', 
                case when post_type = 'page-html' then JSON('["/admin/pages/edit_script"]')
                    else JSON('[]')
                end
        )
    ) AS properties
FROM
    posts
WHERE
     id = $id::int;

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Pages' as title
    , '/admin/pages' as link;

SELECT
    'New Page' as title
    , true as active
WHERE
    $id is null;

SELECT
    title
    , true as active
FROM
    posts
WHERE
    id = $id::int;
    
SELECT
    'dynamic' as component
    , sqlpage.run_sql('admin/pages/.tabs.sql') AS properties;

SELECT
    'alert' as component
    , 'blue' as color
    , 'Page saved successfully.' as title
WHERE
    $saved is not null;

SELECT
    'form_with_html' as component
    , 'Save Page' as validate
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
    'html' as type
    , '<div id="html-content" style="width:100%;border:1px solid #aaa;"></div><div class="m-3"></div>' as html
FROM
    posts
WHERE
     id = $id::int
     and post_type = 'page-html';


SELECT
    'html' as type
    , '<div id="content" placeholder="Your new content goes here!">' || content || '</div>' as html
FROM
    posts
WHERE
     id = $id::int
     and post_type = 'page-templated';

SELECT
    'Publish Immediately' as label
    , 'checkbox' as type
    , 'published' as name
WHERE
    $id is null;

SELECT
    'Published' as label
    , 'checkbox' as type
    , 'published' as name
    , case when published_date is not null then true else false end as checked
    , 'published' as id
FROM
    posts
WHERE
     id = $id::int
     AND $id is not null;

SELECT
    'Published Date' as label
    , 'datetime-local' as type
    , 'published_date' as name
    , 'published_date' as id
    , case when published_date is not null then replace(to_char(published_date at time zone timezone, 'YYYY-MM-DD HH24:MI'), ' ', 'T') else null end as value
FROM
    posts
WHERE
     id = $id::int
     AND $id is not null;

SELECT
    'select' as type
    , 'Timezone' as label
    , 'timezone' as name
    , true as required
    , case when timezone is null then (select setting_value from settings where setting_name = 'default_timezone') else timezone end as value
    , 'timezone' as id
    , (select json_agg(options)
        from
        (
            SELECT json_build_object('label', name, 'value', name) as options
            FROM pg_timezone_names
            ORDER BY name
        ) options) as options
FROM
    posts
WHERE
     id = $id::int
     AND $id is not null;

SELECT
    'html' as component,
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
' as html;