SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Edit Post', 'additional_javascript', '["/admin/posts/edit_post"]')) AS properties;

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Posts' as title
    , '/admin/posts' as link;

select 
    'New Post' as title
    , true as active
WHERE
    $id is null;

select 
    title as title
    , true as active
FROM
    posts
WHERE
    id = $id::int
    AND $id is not null;

SELECT
    'alert' as component
    , 'blue' as color
    , 'Your post was saved!' as title
    , case when published_date is not null then '/' || replace(sqlpage_files.path, '.sql', '') else null end as link
    , 'Click here to view your post' as link_text
    , case when published_date is null then 'It has not yet been published.' else null end as description
FROM
    posts
    left join sqlpage_files on posts.id = sqlpage_files.post_id
WHERE
    $saved = '1'
    AND id = $id::int;

SELECT
    'form_with_html' as component
    , 'Save' as validate
    , 'post-form' as id
    , 'post' as method
    , 'save_post' as action;

SELECT
    'hidden' as type
    , 'id' as name
    , $id as value
WHERE
    $id is not null;

SELECT
    'hidden' as type
    , 'type' as name
    , coalesce($type, 'post') as value
WHERE
    $id is null;

SELECT
    'hidden' as type
    , 'type' as name
    , coalesce($type, 'post') as value
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
     id = $id::int
     AND $id is not null;

SELECT
    'Slug' as label
    , slug as value
    , true as disabled
FROM
    posts
WHERE
     id = $id::int
     AND $id is not null;

SELECT
    'select' as type
    , 'Template' as label
    , 'template_id' as name
    , (select id from template where post_default = true) as value
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
    id = $id::int;

SELECT
    'html' as type
    , '<div id="content" placeholder="Your new content goes here!"></div>' as html
WHERE
    $id is null;

SELECT
    'html' as type
    , '<div id="content">' || content || '</div>' as html
FROM
    posts
WHERE
     id = $id::int
     AND $id is not null;

SELECT
    'html' as type
    , '<hr/>' as html;

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
    , timezone as value
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
    'chart' as component, 
    'blue' as color,
    true as time,
    'Views' as title
WHERE
    $id is not null;

SELECT
    created_at::date as x
    , count(*) as y
FROM
    traffic
WHERE
    post_id = $id::int
group BY
    created_at::date;

SELECT
    'table' as component
WHERE
    $id is not null;

SELECT
    created_at::date as "Date"
    , count(*) as "Views"
FROM
    traffic
WHERE
    post_id = $id::int
group BY
    created_at::date
order BY
    created_at::date desc;
