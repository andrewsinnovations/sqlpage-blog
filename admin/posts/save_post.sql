SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties; 
 
set slug = (
    select lower(value) from (
        select replace(value, '.', '') as value from (
        select replace(value, '--', '-') as value FROM
        (
            select 
            (
            -- remove a bunch of special characters
            TRIM(
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(:title,',', ''), '!', ''), '?', ''), '&', 'and'), ' ', '-'), '--', '-'))
            ) as value
        )
        )
    )
); 

set post_routes = (
    select setting_value from settings where setting_name = 'post_routes'
);

set url = (
    select case 
        WHEN $post_routes = 'ymd_slug' THEN to_char(CURRENT_TIMESTAMP, 'YYYY/MM/DD/') || $slug
        WHEN $post_routes = 'ym_slug' THEN to_char(CURRENT_TIMESTAMP, 'YYYY/MM/') || $slug
        WHEN $post_routes = 'y_slug' THEN to_char(CURRENT_TIMESTAMP, 'YYYY/') || $slug
        WHEN $post_routes = 'date_slug' THEN to_char(CURRENT_TIMESTAMP, 'YYYYMMDD/') || $slug
        WHEN $post_routes = 'slug' THEN $slug
    end
)

set default_timezone = (
    select setting_value from settings where setting_name = 'default_timezone'
)

set sqlpage_path = $url || '.sql';

insert into posts (
    title
    , slug
    , content
    , created_at
    , last_modified
    , post_type
    , published_date
    , template_id
    , timezone
)
SELECT
    :title
    , $slug
    , :content
    , current_timestamp
    , current_timestamp
    , :type
    , case when $published is not null then now() else null end
    , :template_id::int
    , $default_timezone
WHERE
    $id is null;

-- sanitize the submitted ID
set post_id = (
    select case when $id is null then currval('posts_id_seq')::text else $id::text end
)

set post_contents = (
    select 'select ''dynamic'' as component, sqlpage.run_sql(''.post.sql'') as properties;'
);

delete from sqlpage_files 
where 
    path = $sqlpage_path;

insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
    , post_id
)
SELECT
    $sqlpage_path
    , convert_to(coalesce($post_contents, ''), 'UTF8') as contents
    , current_timestamp
    , current_timestamp
    , $post_id::int
WHERE
    case when $published is not null then 1 else 0 end = 1;
    
SELECT
    'redirect' as component
    , '/admin/posts/post?saved=1&id=' || $post_id as link
WHERE
    $id is null;

update posts
set
    title = $title
    , slug = $slug
    , content = :content
    , last_modified = current_timestamp
    , published_date = case when $published_date is not null and $published_date != '' then $published_date::timestamp at time zone $timezone else null end
    , template_id = $template_id::int
    , timezone = $timezone
WHERE
    id = $post_id::integer;

select 'redirect' as component
    , '/admin/posts/post?saved=1&id=' || $id as link;