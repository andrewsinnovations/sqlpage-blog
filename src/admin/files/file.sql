SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql') AS properties;

SELECT
    'breadcrumb' as component;

select 
    'Home' as title
    , '/admin/dashboard' as link;

select 
    'Files' as title
    , '/admin/files' as link;

SELECT
    'Upload New File' as title
    , true as active;

SELECT
    'form' as component
    , 'Save' as validate
    , 'post-form' as id
    , 'post' as method
    , 'save_file' as action;

SELECT
    'hidden' as type
    , 'id' as name
    , $id as value;

SELECT
    'file' as type
    , 'file' as name
    , 'File' as label
    , true as required
WHERE
    $id = 'new';

SELECT
    'foldable' as component
WHERE
    $id != 'new';

SELECT
    'Record Actions' as title
    , '- [Delete Record](delete_post?id=' || $id || ')' as description_md
WHERE
    $id != 'new';
