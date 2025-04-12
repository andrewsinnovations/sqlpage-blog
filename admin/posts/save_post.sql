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
    select case when $post_routes = 'ymd_slug' then strftime('%Y/%m/%d/', current_timestamp) ||  $slug 
        when $post_routes = 'ym_slug' then strftime('%Y/%m/', current_timestamp) || $slug 
        when $post_routes = 'y_slug' then strftime('%Y/', current_timestamp) || $slug 
        when $post_routes = 'date_slug' then strftime('%Y%m%d/', current_timestamp) || $slug 
        when $post_routes = 'slug' then $slug 
    end
)

set sqlpage_path = $url || '.sql';

insert into posts (
    title
    , slug
    , content
    , created_at
    , last_modified
    , post_type
    , published
    , template_id
)
SELECT
    :title
    , $slug
    , :content
    , current_timestamp
    , current_timestamp
    , :type
    , case when $published is not null then 1 else 0 end
    , :template_id
WHERE
    :id = 'new';

-- sanitize the submitted ID
set post_id = (
    select case when :id = 'new' then last_insert_rowid() else cast(:id as integer) end
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
    , $post_contents as contents
    , current_timestamp
    , current_timestamp
    , $post_id
WHERE
    case when $published is not null then 1 else 0 end = 1;
    
SELECT
    'redirect' as component
    , '/admin/posts/post?saved=1&id=' || $post_id as link
WHERE
    :id = 'new';

update posts
set
    title = :title
    , slug = $slug
    , content = :content
    , last_modified = current_timestamp
    , published = case when $published is not null then 1 else 0 end
    , template_id = :template_id
WHERE
    id = :id;

select 'redirect' as component
    , '/admin/posts/post?saved=1&id=' || :id as link;