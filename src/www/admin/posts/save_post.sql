SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SET
    slug = (
        SELECT
            lower(value)
        FROM
            (
                SELECT
                    replace(value, '.', '') AS value
                FROM
                    (
                        SELECT
                            replace(value, '--', '-') AS value
                        FROM
                            (
                                SELECT
                                    (
                                        -- remove a bunch of special characters
                                        trim(
                                            replace(
                                                replace(
                                                    replace(
                                                        replace(
                                                            replace(replace(:title, ',', ''), '!', ''),
                                                            '?',
                                                            ''
                                                        ),
                                                        '&',
                                                        'and'
                                                    ),
                                                    ' ',
                                                    '-'
                                                ),
                                                '--',
                                                '-'
                                            )
                                        )
                                    ) AS value
                            )
                    )
            )
    )
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
    url = (
        SELECT
            CASE
                WHEN $post_routes = 'ymd_slug' THEN to_char(current_timestamp, 'YYYY/MM/DD/') || $slug
                WHEN $post_routes = 'ym_slug' THEN to_char(current_timestamp, 'YYYY/MM/') || $slug
                WHEN $post_routes = 'y_slug' THEN to_char(current_timestamp, 'YYYY/') || $slug
                WHEN $post_routes = 'date_slug' THEN to_char(current_timestamp, 'YYYYMMDD/') || $slug
                WHEN $post_routes = 'slug' THEN $slug
            END
    )
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
    sqlpage_path = $url || '.sql'
;



INSERT INTO
    posts (
        title,
        slug,
        content,
        created_at,
        last_modified,
        post_type,
        published_date,
        template_id,
        timezone
    )
SELECT
:title,
    $slug,
:content,
    current_timestamp,
    current_timestamp,
:type,
    CASE
        WHEN $published IS NOT NULL THEN now()
        ELSE NULL
    END,
:template_id::int,
    $default_timezone
WHERE
    $id IS NULL
;



-- sanitize the submitted ID
SET
    post_id = (
        SELECT
            CASE
                WHEN $id IS NULL THEN currval('posts_id_seq')::text
                ELSE $id::text
            END
    )
SET
    post_contents = (
        SELECT
            'select ''dynamic'' as component, sqlpage.run_sql(''.post.sql'') as properties;'
    )
;



DELETE FROM sqlpage_files
WHERE
    path = $sqlpage_path
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
    $post_id::int
WHERE
    CASE
        WHEN $published IS NOT NULL THEN 1
        ELSE 0
    END = 1
;



SELECT
    'redirect' AS component,
    '/admin/posts/post?saved=1&id=' || $post_id AS link
WHERE
    $id IS NULL
;



UPDATE posts
SET
    title = $title,
    slug = $slug,
    content =:content,
    last_modified = current_timestamp,
    published_date = CASE
        WHEN $published_date IS NOT NULL
        AND $published_date != '' THEN $published_date::timestamp at time zone $timezone
        ELSE NULL
    END,
    template_id = $template_id::int,
    timezone = $timezone
WHERE
    id = $post_id::integer
;



SELECT
    'redirect' AS component,
    '/admin/posts/post?saved=1&id=' || $id AS link
;