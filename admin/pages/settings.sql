SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql'
        , json_build_object(
            'shell_title', 'Edit Page Settings',
            'additional_javascript', JSON('["/admin/pages/edit_settings"]')
        )
    ) AS properties;

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
    , sqlpage.run_sql('admin/pages/.tabs.sql') AS properties
WHERE
    $id is not null;

SELECT
    'alert' as component
    , 'blue' as color
    , 'Page saved successfully.' as title
WHERE
    $saved is not null;

SELECT
    'alert' as component
    , 'red' as color
    , 'Invalid path. Cannot set a path under /admin/ or /sqlpage/ or /uploads/' as title
WHERE
    $invalid_path is not null;

SELECT
    'alert' as component
    , 'red' as color
    , 'The supplied path already exists.' as title
WHERE
    $path_exists is not null;

SELECT
    'form_with_html' as component
    , 'Save Page' as validate
    , 'template-form' as id
    , 'post' as method
    , 'save_settings' as action;

SELECT
    'hidden' as type
    , 'id' as name
    , $id as value
WHERE
    $id is not null;

SELECT
    'select' as type
    , 'type' as name
    , 'Page Type' as label
    , true as required
    , 'page_type' as id
    , '[{"value": "page-html", "label": "HTML Page"}, {"value": "page-templated", "label": "Templated Page"}]' as options
WHERE
    $id is null;

SELECT
    'select' as type
    , 'type' as name
    , 'Page Type' as label
    , post_type as value
    , true as required
    , 'page_type' as id
    , '[{"value": "page-html", "label": "HTML Page"}, {"value": "page-templated", "label": "Templated Page"}]' as options
FROM
    posts
WHERE
     id = $id::int
     AND $id is not null;

SELECT
    'select' as type
    , 'Template' as label
    , 'template_id' as name
    , 'template_id' as id
    , (
        select json_agg(value) 
		from (
			select json_build_object('value', id, 'label', name) as value
        	from template
			order by name
		)
    ) as options
WHERE
    $id is null;

SELECT
    'select' as type
    , 'Template' as label
    , 'template_id' as name
    , 'template_id' as id
    , template_id as value
    , (
        select json_agg(value) 
		from (
			select json_build_object('value', id, 'label', name) as value
        	from template
			order by name
		)
    ) as options
FROM
    posts
WHERE
     id = $id::int
     AND $id is not null;

SELECT
    'title' as name
    , 'Title' as label
    , true as required
WHERE
    $id is null;

SELECT
    'title' as name
    , 'Title' as label
    , true as required
    , title as value
FROM
    posts
WHERE
     id = $id::int;

SELECT
    'path' as name
    , 'Path' as label
    , true as required
WHERE
     $id is null;

SELECT
    'path' as name
    , 'Path' as label
    , true as required
    , slug as value
FROM
    posts
WHERE
     id = $id::int;

