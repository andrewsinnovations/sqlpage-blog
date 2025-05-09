SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Files')) AS properties;

set date_format = (
    select coalesce(setting_value, 'MM/DD/YYYY')
    from settings
    where setting_name = 'dashboard_date_format'
);

set default_timezone = (
    select setting_value from settings where setting_name = 'default_timezone'
)

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Files' as title
    , '/admin/files' as link
    , true as active;

SELECT
    'alert' as component
    , 'red' as color
    , 'The supplied file already existed.' as title
WHERE
    $already_exists = '1';

SELECT
    'alert' as component
    , 'green' as color
    , 'File uploaded successfully.' as title
WHERE
    $success = '1';

SELECT
    'button' as component
    , 'mt-3' as class;

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
    , to_char(created_at at time zone $default_timezone, $date_format) as "Uploaded At"
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

