SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'redirect' AS component,
    '/admin/pages/settings?invalid_path=1' || CASE
        WHEN $id IS NOT NULL THEN '&id=' || $id
        ELSE ''
    END AS link
WHERE
:path LIKE '/admin/%'
    OR:path LIKE '/sqlpage/%'
    OR:path LIKE '/uploads/%'
    OR:path IN (
        '.env',
        '.env.example',
        '.gitignore',
        '.page-html.sql',
        '.page-html',
        '.page-templated.sql',
        '.page-templated',
        '.post-data.sql',
        '.post-data',
        '.post.sql',
        '.page-data.sql',
        '.page-data',
        '.post',
        '404.sql',
        '404',
        'compose.yaml',
        'LICENSE',
        'README.md',
        '/.env',
        '/.env.example',
        '/.gitignore',
        '/.page-html.sql',
        '/.page-html',
        '/.page-templated.sql',
        '/.page-templated',
        '/.post-data.sql',
        '/.post-data',
        '/.page-data.sql',
        '/.page-data',
        '/.post.sql',
        '/.post',
        '/404.sql',
        '/404',
        '/compose.yaml',
        '/LICENSE',
        '/README.md'
    )
;



SELECT
    'redirect' AS component,
    '/admin/pages/settings?path_exists=1' || CASE
        WHEN $id IS NOT NULL THEN '&id=' || $id
        ELSE ''
    END AS link
WHERE
    EXISTS (
        SELECT
            1
        FROM
            posts
        WHERE
            (
                slug = CASE
                    WHEN:path NOT LIKE '/%' THEN '/' ||:path
                    ELSE:path
                END
                OR slug = '/'
                AND:path = '/'
            )
            AND (
                $id IS NULL
                OR id != $id::int
            )
    )
;



UPDATE posts
SET
    title =:title,
    post_type =:type,
    slug =:path,
    last_modified = current_timestamp,
    template_id = CASE
        WHEN:type = 'page-html' THEN NULL
        ELSE:template_id::int
    END
WHERE
    id = $id::int
;



SELECT
    'redirect' AS component,
    '/admin/pages/settings?saved=1&id=' || $id AS link
WHERE
    $id IS NOT NULL
;



INSERT INTO
    posts (
        title,
        post_type,
        slug,
        created_at,
        last_modified,
        content,
        timezone,
        template_id
    )
SELECT
:title,
:type,
    CASE
        WHEN:path NOT LIKE '/%' THEN '/' ||:path
        ELSE:path
    END,
    current_timestamp,
    current_timestamp,
    '',
    (
        SELECT
            setting_value
        FROM
            settings
        WHERE
            setting_name = 'default_timezone'
        LIMIT
            1
    ),
    CASE
        WHEN:type = 'page-html' THEN NULL
        ELSE:template_id::int
    END
WHERE
    $id IS NULL
RETURNING
    'redirect' AS component,
    '/admin/pages/settings?saved=1&id=' || id AS link
;