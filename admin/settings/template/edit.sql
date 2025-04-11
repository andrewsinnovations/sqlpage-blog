SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql'
        , json_object(
            'shell_title', 'Edit Template',
            'additional_javascript', JSON('["https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.0/min/vs/loader.min.js"]'),
            'additional_javascript_module', JSON('["/admin/settings/template/edit_script"]')
        )
    ) AS properties;

SELECT
    'alert' as component
    , 'blue' as color
    , 'Template saved successfully.' as title
WHERE
    $saved is not null;

select 'dynamic' as component
    , sqlpage.run_sql('admin/settings/template/.tabs.sql') AS properties;

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
     id = $id;

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
    id = $id;

SELECT
    'foldable' as component
WHERE
    $id is not null;

SELECT
    'Record Actions' as title
    , '- [Delete Record](delete?id=' || $id || ')' as description_md
WHERE
    $id is not null;
