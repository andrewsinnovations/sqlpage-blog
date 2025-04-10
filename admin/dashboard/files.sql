SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/dashboard/.tabs.sql') AS properties;

SELECT
    'alert' as component
    , 'red' as color
    , 'The supplied file already existed.' as title
WHERE
    $already_exists = 1;

SELECT
    'alert' as component
    , 'green' as color
    , 'File uploaded successfully.' as title
WHERE
    $success = 1;

SELECT
    'button' as component;

select 
    'Upload New File' as title
    , 'green' as color
    , 'file?id=new' as link
    , 'plus' as icon;

SELECT
    'table' as component
    , 'title' as markdown
    , 'url' as markdown
    , true as sort
    , 'No files have been uploaded yet.' as empty_description;

SELECT
    '[' || original_file_name || '](' || path || ')' as title
    , path as url
    , created_at
FROM
    uploaded_files
order BY
    created_at desc;

-- SELECT
--     'table' as component
--     , 'title' as markdown
--     , 'url' as markdown
--     , true as sort
--     , 'No posts have been created yet.' as empty_description;   

