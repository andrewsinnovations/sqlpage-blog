SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SET
    post_routes = (
        SELECT
            setting_value
        FROM
            settings
        WHERE
            setting_name = 'post_routes'
    )
;



SET
    default_timezone = (
        SELECT
            setting_value
        FROM
            settings
        WHERE
            setting_name = 'default_timezone'
    )
SET
    path = (
        SELECT
            CASE
                WHEN slug LIKE '/%' THEN substring(slug, 2)
                ELSE slug
            END AS slug
        FROM
            (
                SELECT
                    CASE
                        WHEN slug = '/' THEN 'index'
                        WHEN slug != '/'
                        AND slug LIKE '%/' THEN slug || 'index'
                        ELSE slug
                    END AS slug
                FROM
                    posts
                WHERE
                    id = $id::int
            )
    )
;



SET
    sqlpage_path = (
        CASE
            WHEN $path = 'index' THEN 'index.sql'
            WHEN $path != 'index'
            AND $path LIKE '%/' THEN $path || 'index.sql'
            ELSE $path || '.sql'
        END
    )
SET
    post_contents = (
        SELECT
            CASE
                WHEN post_type = 'page-html' THEN 'select ''dynamic'' as component, sqlpage.run_sql(''.page-html.sql'') as properties;'
                WHEN post_type = 'page-templated' THEN 'select ''dynamic'' as component, sqlpage.run_sql(''.page-templated.sql'') as properties;'
            END
        FROM
            posts
        WHERE
            id = $id::int
    )
;



DELETE FROM sqlpage_files
WHERE
    path = $sqlpage_path
    OR post_id = $id::int
;



INSERT INTO
    sqlpage_files (
        path,
        contents,
        created_at,
        last_modified,
        post_id
    )
SELECT
    $sqlpage_path,
    convert_to(coalesce($post_contents, ''), 'UTF8') AS contents,
    current_timestamp,
    current_timestamp,
    $id::int
WHERE
    $published IS NOT NULL
;



DELETE FROM sqlpage_files
WHERE
    path = 'sqlpage/templates/page_' || $id || '.handlebars'
;



INSERT INTO
    sqlpage_files (
        path,
        contents,
        created_at,
        last_modified,
        post_id
    )
SELECT
    'sqlpage/templates/page_' || $id || '.handlebars',
    convert_to(coalesce(:content, ''), 'UTF8') AS contents,
    current_timestamp,
    current_timestamp,
    $id::int
WHERE
    $published IS NOT NULL
;



UPDATE posts
SET
    content =:content,
    last_modified = current_timestamp,
    published_date = CASE
        WHEN $published_date IS NOT NULL
        AND $published_date != '' THEN $published_date::timestamp at time zone $timezone
        ELSE NULL
    END,
    timezone = $timezone
WHERE
    id = $id::integer
;



SELECT
    'redirect' AS component,
    '/admin/pages/edit?saved=1&id=' || $id AS link
;