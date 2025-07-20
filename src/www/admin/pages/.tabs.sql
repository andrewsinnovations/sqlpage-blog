SELECT
    'tab' AS component
;



SELECT
    'Page Settings' AS title,
    'settings?id=' || $id AS link,
    'settings' AS name,
    CASE
        WHEN sqlpage.path () = '/admin/pages/settings' THEN TRUE
        ELSE FALSE
    END AS active
;



SELECT
    'Edit Page' AS title,
    'edit?id=' || $id AS link,
    'contents' AS name,
    CASE
        WHEN sqlpage.path () = '/admin/pages/edit' THEN TRUE
        ELSE FALSE
    END AS active
;



SELECT
    'Traffic' AS title,
    'traffic?id=' || $id AS link,
    'contents' AS name,
    CASE
        WHEN sqlpage.path () = '/admin/pages/traffic' THEN TRUE
        ELSE FALSE
    END AS active
;