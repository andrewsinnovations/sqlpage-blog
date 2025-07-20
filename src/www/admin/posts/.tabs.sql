SELECT
    'tab' AS component,
    'mt-3' AS class
;



SELECT
    'Edit Post' AS title,
    'post?id=' || $id AS link,
    CASE
        WHEN sqlpage.path () = '/admin/posts/post' THEN TRUE
        ELSE FALSE
    END AS active
;



SELECT
    'Traffic' AS title,
    'traffic?id=' || $id AS link,
    CASE
        WHEN sqlpage.path () IN ('/admin/posts/traffic') THEN TRUE
        ELSE FALSE
    END AS active
;