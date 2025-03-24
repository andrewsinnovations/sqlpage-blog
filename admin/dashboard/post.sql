SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/shell.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('sqlpage/admin/tabs_dashboard.sql', json_object('type', coalesce($type, 'post'))) AS properties;

SELECT
    'form_with_html' as component
    , 'Save' as validate
    , 'post-form' as id
    , 'post' as method
    , 'save_post' as action;

SELECT
    'hidden' as type
    , 'id' as name
    , $id as value;

SELECT
    'hidden' as type
    , 'type' as name
    , coalesce($type, 'post') as value
WHERE
    $id = 'new';

SELECT
    'hidden' as type
    , 'type' as name
    , coalesce($type, 'post') as value
FROM
   posts
WHERE
    id = $id
    AND $id != 'new';

SELECT
    'title' as name
    , 'Title' as label
    , true as required
WHERE
    $id = 'new';

SELECT
    'title' as name
    , 'Title' as label
    , true as required
    , title as value
FROM
    posts
WHERE
     id = $id
     AND $id != 'new';

SELECT
    'Slug' as label
    , slug as value
    , true as disabled
FROM
    posts
WHERE
     id = $id
     AND $id != 'new';

SELECT
    'html' as type
    , '<div id="content" placeholder="Your new content goes here!"></div>' as html
WHERE
    $id = 'new';

SELECT
    'html' as type
    , '<div id="content">' || content || '</div>' as html
FROM
    posts
WHERE
     id = $id
     AND $id != 'new';

SELECT
    'html' as type
    , '<hr/>' as html;

SELECT
    'Publish Immediately' as label
    , 'checkbox' as type
    , 'published' as name
WHERE
    $id = 'new';

SELECT
    'Published' as label
    , 'checkbox' as type
    , 'published' as name
    , case when published = 1 then true else 0 end as checked
FROM
    posts
WHERE
     id = $id
     AND $id != 'new';

SELECT
    'html' as component
    , '<script>
    document.addEventListener("DOMContentLoaded", () => {
    
      // Turn the <textarea> into a Trumbowyg editor
      const editor = document.getElementById("content");
      window.$(editor).trumbowyg();
    });</script>' as html;

SELECT
    'foldable' as component
WHERE
    $id != 'new';

SELECT
    'Record Actions' as title
    , '- [Delete Record](delete_post?id=' || $id || ')' as description_md
WHERE
    $id != 'new';
