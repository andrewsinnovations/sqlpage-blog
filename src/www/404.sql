SELECT
    'status_code' AS component,
    404 AS status
;



INSERT INTO
    traffic (url, status_code)
SELECT
    sqlpage.path (),
    404
;



SET
    post = (
        SELECT
            json_build_object(
                'title',
                'Page Not Found',
                'slug_path',
                '',
                'db_path',
                '',
                'post_date',
                '',
                'content',
                'Sorry, the URL you are trying to access was not found.'
            ) AS post_data
    )
;



SET
    settings = (
        SELECT
            (sqlpage.run_sql ('.settings_data.sql')::jsonb) -> 0 -> 'settings'
    )
;



SELECT
    'shell-empty' AS component
;



SELECT
    'template_' || id AS component,
    json($post) AS post,
    json($settings) AS settings
FROM
    template
WHERE
    post_default = TRUE
;