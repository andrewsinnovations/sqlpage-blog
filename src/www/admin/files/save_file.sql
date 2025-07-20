SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'redirect' AS component,
    'files?already_exists=1' AS link
WHERE
    EXISTS (
        SELECT
            1
        FROM
            uploaded_files
        WHERE
            original_file_name = sqlpage.uploaded_file_name ('file')
    )
;



INSERT INTO
    uploaded_files (
        path,
        original_file_name,
        created_at,
        updated_at,
        mime_type
    )
SELECT
    replace(
        sqlpage.persist_uploaded_file ('file', 'uploads'),
        '\',
        '/'
    ),
    sqlpage.uploaded_file_name ('file'),
    current_timestamp,
    current_timestamp,
    sqlpage.uploaded_file_mime_type ('file')
;



SELECT
    'redirect' AS component,
    'index?success=1' AS link
;