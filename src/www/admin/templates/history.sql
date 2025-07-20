SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
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
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Template History')
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
    'Templates' AS title,
    '/admin/templates' AS link
;



SELECT
    'New Template' AS title,
    TRUE AS active
WHERE
    $id IS NULL
;



SELECT
    name AS title,
    TRUE AS active
FROM
    template
WHERE
    id = $id::int
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/templates/.tabs.sql') AS properties
;



SELECT
    'table' AS component,
    'version' AS markdown
;



WITH
    revisions AS (
        SELECT
            id,
            row_number() OVER (
                ORDER BY
                    created_at
            ) AS revision,
            created_at,
            name
        FROM
            template_history
        WHERE
            template_id = $id::int
        ORDER BY
            created_at DESC
    ),
    special_revisions AS (
        SELECT
            max(revision) AS last_revision
        FROM
            revisions
    )
SELECT
    '[' || CASE
        WHEN revision = 1 THEN 'Initial Version'
        ELSE 'Version ' || revision
    END || CASE
        WHEN revision = last_revision THEN ' - Current Version'
        ELSE ''
    END || '](revision?id=' || id || ')' AS version,
    to_char(created_at, $date_format) AS "Created At",
    name
FROM
    revisions,
    special_revisions
ORDER BY
    revision DESC