SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object(
            'shell_title',
            'Edit Post',
            'additional_javascript',
            '["/admin/posts/edit_post"]'
        )
    ) AS properties
;



SELECT
    'breadcrumb' AS component
;



SELECT
    'Home' AS title,
    '/admin/dashboard' AS link
;



SELECT
    'Posts' AS title,
    '/admin/posts' AS link
;



SELECT
    'New Post' AS title,
    TRUE AS active
WHERE
    $id IS NULL
;



SELECT
    title AS title,
    TRUE AS active
FROM
    posts
WHERE
    id = $id::int
    AND $id IS NOT NULL
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/posts/.tabs.sql') AS properties
;



SELECT
    'chart' AS component,
    'blue' AS color,
    TRUE AS time,
    'Views' AS title
WHERE
    $id IS NOT NULL
;



SELECT
    created_at::date AS x,
    count(*) AS y
FROM
    traffic
WHERE
    post_id = $id::int
GROUP BY
    created_at::date
ORDER BY
    created_at::date
;



SELECT
    'table' AS component
WHERE
    $id IS NOT NULL
;



SELECT
    created_at::date AS "Date",
    count(*) AS "Views"
FROM
    traffic
WHERE
    post_id = $id::int
GROUP BY
    created_at::date
ORDER BY
    created_at::date DESC
;
