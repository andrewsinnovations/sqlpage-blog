SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'redirect' as component
    , 'files?already_exists=1' as link
WHERE
    exists (SELECT 1 FROM uploaded_files WHERE original_file_name = sqlpage.uploaded_file_name('file'));

insert into uploaded_files (
    path
    , original_file_name
    , created_at
    , updated_at
    , mime_type
)
SELECT
    replace(sqlpage.persist_uploaded_file('file', 'uploads'), '\', '/')
    , sqlpage.uploaded_file_name('file')
    , current_timestamp
    , current_timestamp
    , sqlpage.uploaded_file_mime_type('file');

SELECT
    'redirect' as component
    , 'files?success=1' as link;