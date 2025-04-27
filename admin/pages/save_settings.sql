SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties; 
   
SELECT
    'redirect' as component
    , '/admin/pages/settings?invalid_path=1' || case when $id is not null then '&id=' || $id else '' end as link
WHERE
    :path like '/admin/%' 
    or :path like '/sqlpage/%' 
    or :path like '/uploads/%'
    or :path in (
        '.env'
        , '.env.example'
        , '.gitignore'
        , '.page-html.sql'
        , '.page-html'
        , '.page-templated.sql'
        , '.page-templated'        
        , '.post-data.sql'
        , '.post-data'
        , '.post.sql'
        , '.page-data.sql'
        , '.page-data'  
        , '.post'
        , '404.sql'
        , '404'
        , 'compose.yaml'
        , 'LICENSE'
        , 'README.md'
        , '/.env'
        , '/.env.example'
        , '/.gitignore'
        , '/.page-html.sql'
        , '/.page-html'
        , '/.page-templated.sql'
        , '/.page-templated'        
        , '/.post-data.sql'
        , '/.post-data'
        , '/.page-data.sql'
        , '/.page-data'        
        , '/.post.sql'
        , '/.post'
        , '/404.sql'
        , '/404'
        , '/compose.yaml'
        , '/LICENSE'
        , '/README.md'
    );

SELECT
    'redirect' as component
    , '/admin/pages/settings?path_exists=1' || case when $id is not null then '&id=' || $id else '' end as link
WHERE
    exists (
        SELECT 1
        FROM posts
        WHERE 
            (
                slug = case when :path not like '/%' then '/' || :path else :path end
                or slug = '/' and :path = '/'
            )
            AND (
                $id is null 
                or id != $id::int
            )
    );

UPDATE
    posts
SET
    title = :title
    , post_type = :type
    , slug = :path
    , last_modified = current_timestamp
    , template_id = case when :type = 'page-html' then null else :template_id::int end
WHERE
    id = $id::int;

SELECT
    'redirect' as component
    , '/admin/pages/settings?saved=1&id=' || $id as link
WHERE
    $id is not null;

insert into posts (
    title
    , post_type
    , slug
    , created_at
    , last_modified
    , content
    , timezone
    , template_id
)
SELECT
    :title
    , :type
    , case when :path not like '/%' then '/' || :path else :path end
    , current_timestamp
    , current_timestamp
    , ''
    , (select setting_value from settings where setting_name = 'default_timezone' limit 1)
    , case when :type = 'page-html' then null else :template_id::int end
WHERE
    $id is null
RETURNING
    'redirect' as component
    , '/admin/pages/settings?saved=1&id=' || id as link;