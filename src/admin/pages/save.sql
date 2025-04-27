SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties; 
 
set post_routes = (
    select setting_value from settings where setting_name = 'post_routes'
);

set default_timezone = (
    select setting_value from settings where setting_name = 'default_timezone'
)

set path = (
    SELECT
        case when slug like '/%' then substring(slug, 2) else slug end as slug
    FROM
    (
        select 
            case 
                when slug = '/' then 'index'
                when slug != '/' and slug like '%/' then slug || 'index'
                else slug
            end as slug
        from posts 
            where id = $id::int
    )
);

set sqlpage_path = (
    case 
        when $path = 'index' then 'index.sql'
        when $path != 'index' and $path like '%/' then $path || 'index.sql'
        else $path || '.sql'
    end
)

set post_contents = (
    select 
        case 
            when post_type = 'page-html' then 'select ''dynamic'' as component, sqlpage.run_sql(''.page-html.sql'') as properties;' 
            when post_type = 'page-templated' then 'select ''dynamic'' as component, sqlpage.run_sql(''.page-templated.sql'') as properties;'
        end 
    FROM
        posts
    WHERE
        id = $id::int
);

delete from sqlpage_files 
where 
    path = $sqlpage_path
    or post_id = $id::int;

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
    , $id::int
WHERE
    $published is not null;

delete from sqlpage_files
WHERE
    path = 'sqlpage/templates/page_' || $id || '.handlebars';

insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
    , post_id
)
SELECT
    'sqlpage/templates/page_' || $id || '.handlebars'
    , convert_to(coalesce(:content, ''), 'UTF8') as contents
    , current_timestamp
    , current_timestamp
    , $id::int
WHERE
    $published is not null;

update posts
set
    content = :content
    , last_modified = current_timestamp
    , published_date = case when $published_date is not null and $published_date != '' then $published_date::timestamp at time zone $timezone else null end
    , timezone = $timezone
WHERE
    id = $id::integer;

select 'redirect' as component
    , '/admin/pages/edit?saved=1&id=' || $id as link;