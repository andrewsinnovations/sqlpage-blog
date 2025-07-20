SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Posts')
    ) AS properties
;



SET
    date_format = (
        SELECT
            coalesce(setting_value, 'MM/DD/YYYY')
        FROM
            settings
        WHERE
            setting_name = 'dashboard_date_format'
    )
;



SELECT
    'alert' AS component,
    'blue' AS color,
    'Post deleted successfully.' AS title
WHERE
    $deleted = '1'
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
    '/admin/posts' AS link,
    TRUE AS active
;



SELECT
    'button' AS component,
    'mt-3' AS class
;



SELECT
    'Create New Post' AS title,
    'green' AS color,
    'post?type=post' AS link,
    'plus' AS icon
;



SELECT
    'table' AS component,
    'title' AS markdown,
    'url' AS markdown,
    TRUE AS sort,
    'No posts have been created yet.' AS empty_description
;



SELECT
    '[' || CASE
        WHEN trim(title) != '' THEN title
        ELSE 'No title set'
    END || '](post?id=' || id || ')' AS title,
    CASE
        WHEN posts.published_date IS NOT NULL THEN '[' || replace(sqlpage_files.path, '.sql', '') || '](/' || replace(sqlpage_files.path, '.sql', '') || ')'
        ELSE 'Not published'
    END AS url,
    to_char(
        posts.last_modified at time zone timezone,
        $date_format
    ) AS "Last Updated",
    to_char(
        posts.published_date at time zone timezone,
        $date_format
    ) AS published,
    coalesce(traffic_data.traffic, 0) AS views
FROM
    posts
    LEFT JOIN sqlpage_files ON posts.id = sqlpage_files.post_id
    LEFT JOIN (
        SELECT
            post_id,
            count(*) AS traffic
        FROM
            traffic
        GROUP BY
            post_id
    ) traffic_data ON posts.id = traffic_data.post_id
    LEFT JOIN (
        SELECT
            post_id,
            count(*) AS traffic
        FROM
            traffic
        WHERE
            created_at >= now()::date + interval '-1 day'
        GROUP BY
            post_id
    ) traffic_data_today ON posts.id = traffic_data_today.post_id
    LEFT JOIN (
        SELECT
            post_id,
            count(*) AS traffic
        FROM
            traffic
        WHERE
            created_at >= now()::date + interval '-30 day'
        GROUP BY
            post_id
    ) traffic_data_last_30 ON posts.id = traffic_data_last_30.post_id
WHERE
    post_type = 'post'
ORDER BY
    posts.last_modified DESC
;