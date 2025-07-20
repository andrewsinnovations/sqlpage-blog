SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Files')
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



SET
    default_timezone = (
        SELECT
            setting_value
        FROM
            settings
        WHERE
            setting_name = 'default_timezone'
    )
SELECT
    'breadcrumb' AS component
;



SELECT
    'Home' AS title,
    '/admin/dashboard' AS link
;



SELECT
    'Files' AS title,
    '/admin/files' AS link,
    TRUE AS active
;



SELECT
    'alert' AS component,
    'red' AS color,
    'The supplied file already existed.' AS title
WHERE
    $already_exists = '1'
;



SELECT
    'alert' AS component,
    'green' AS color,
    'File uploaded successfully.' AS title
WHERE
    $success = '1'
;



SELECT
    'button' AS component,
    'mt-3' AS class
;



SELECT
    'Upload New File' AS title,
    'green' AS color,
    'file?id=new' AS link,
    'plus' AS icon
;



SELECT
    'table' AS component,
    'title' AS markdown,
    'url' AS markdown,
    TRUE AS sort,
    'No files have been uploaded yet.' AS empty_description
;



SELECT
    '[' || original_file_name || '](' || path || ')' AS title,
    path AS url,
    to_char(
        created_at at time zone $default_timezone,
        $date_format
    ) AS "Uploaded At"
FROM
    uploaded_files
ORDER BY
    created_at DESC
;



-- SELECT
--     'table' as component
--     , 'title' as markdown
--     , 'url' as markdown
--     , true as sort
--     , 'No posts have been created yet.' as empty_description;
