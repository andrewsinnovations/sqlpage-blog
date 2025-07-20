SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Template History')
    ) AS properties
;



SET
    template_id = (
        SELECT
            template_id
        FROM
            template_history
        WHERE
            id = $id::int
    )
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/templates/.tabs.sql',
        json_object('id', $template_id)
    ) AS properties
;



SELECT
    'breadcrumb' AS component
;



SELECT
    template.name AS title,
    'history?id=' || template.id AS link
FROM
    template_history
    INNER JOIN template ON template.id = template_history.template_id
WHERE
    template_history.id = $id::int
;



SELECT
    'Revision ' || template_history.created_at AS title,
    TRUE AS active
FROM
    template_history
WHERE
    template_history.id = $id::int
;



SELECT
    'button' AS component,
    'mt-2' AS class
;



-- show restore button but only if this is not the most recent revision
SELECT
    'Restore This Version' AS title,
    'green' AS color,
    'restore?id=' || $id AS link
WHERE
    $id::int != (
        SELECT
            max(template_history.id)
        FROM
            template_history
        WHERE
            template_history.template_id = (
                SELECT
                    template_id
                FROM
                    template_history
                WHERE
                    id = $id::int
            )
    )
SELECT
    'text' AS component,
    '```
' || content || '
```' AS contents_md
FROM
    template_history
WHERE
    id = $id::int
;