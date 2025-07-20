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
    'Pages' AS title,
    '/admin/pages' AS link,
    TRUE AS active
;



SELECT
    'button' AS component,
    'mt-3' AS class
;



SELECT
    'Create New Page' AS title,
    'green' AS color,
    'settings' AS link,
    'plus' AS icon
;



SELECT
    'table' AS component,
    'title' AS markdown,
    'url' AS markdown,
    TRUE AS sort,
    'No pages have been created yet.' AS empty_description
;



SELECT
    '[' || CASE
        WHEN trim(posts.title) != '' THEN posts.title
        ELSE 'No title set'
    END || '](settings?id=' || posts.id || ')' AS title,
    CASE
        WHEN posts.published_date IS NOT NULL THEN slug
        ELSE 'Not Published'
    END AS url,
    CASE
        WHEN post_type = 'page-html' THEN 'HTML'
        WHEN post_type = 'page-templated' THEN 'Templated'
        ELSE post_type
    END AS type,
    CASE
        WHEN post_type = 'page-templated' THEN template.name
        ELSE ''
    END AS template,
    to_char(
        posts.last_modified at time zone timezone,
        $date_format
    ) AS "Last Updated",
    coalesce(traffic_data.traffic, 0) AS views
FROM
    posts
    LEFT JOIN template ON posts.template_id = template.id
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
    post_type IN ('page-html', 'page-templated')
ORDER BY
    posts.last_modified DESC
;