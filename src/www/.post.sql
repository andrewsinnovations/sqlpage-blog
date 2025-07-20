SET
    search_path = substr(lower(sqlpage.path ()) || '.sql', 2)
;



SET
    post_id = (
        SELECT
            post_id
        FROM
            sqlpage_files
        WHERE
            lower(path) = $search_path
    )
SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('404.sql') AS properties
WHERE
    $post_id IS NULL
;



SET
    template_id = (
        SELECT
            template_id
        FROM
            posts
        WHERE
            id = $post_id::int
    )
;



SELECT
    'shell-empty' AS component
WHERE
    $post_id IS NOT NULL
;



INSERT INTO
    traffic (post_id, url)
SELECT
    $post_id::int,
    sqlpage.path ()
WHERE
    $post_id IS NOT NULL
;



SET
    post = (
        SELECT
            (sqlpage.run_sql ('.post_data.sql')::jsonb) -> 0 -> 'posts' -> 0
    )
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
    'template_' || $template_id AS component,
    json($post) AS post,
    json($posts) AS posts,
    json($settings) AS settings
WHERE
    $post_id IS NOT NULL
;