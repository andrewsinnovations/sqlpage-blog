SELECT
    'tab' AS component,
    'mt-3' AS class
;



SELECT
    'Edit Template' AS title,
    'edit?id=' || $id AS link,
    CASE
        WHEN sqlpage.path () = '/admin/templates/edit' THEN TRUE
        ELSE FALSE
    END AS active
;



SELECT
    'View Revision History' AS title,
    'history?id=' || $id AS link,
    CASE
        WHEN sqlpage.path () IN (
            '/admin/templates/history',
            '/admin/templates/revision'
        ) THEN TRUE
        ELSE FALSE
    END AS active
;