SELECT
    'redirect' AS component,
    '/admin/install' AS link
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            login
    )
;



INSERT INTO
    traffic (url)
VALUES
    ('/')
;



SELECT
    'shell-empty' AS component
;



SET
    posts = (
        SELECT
            (
                sqlpage.run_sql (
                    '.post_data.sql',
                    json_build_object('all_posts', 'true')
                )::jsonb
            ) -> 0 -> 'posts'
    )
;



SET
    settings = (
        SELECT
            (sqlpage.run_sql ('.settings_data.sql')::jsonb) -> 0 -> 'settings'
    )
;



SELECT
    'home' AS component,
    json($posts) AS posts,
    json($settings) AS settings
;