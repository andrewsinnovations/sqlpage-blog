SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Delete Post')) AS properties
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'alert' as component
    , 'red' as color
    , 'You did not confirm the deletion of this post.' as title
WHERE
    sqlpage.request_method() = 'GET'
    and $invalid = 1;

select
    'text' as component
    , 'Are you sure you want to delete this post?' as title
    , 'red' as color
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'text' as component
    , 'Post Name: **' || title || '**

Created at ' || created_at || '

It cannot be retrieved.' as contents_md
FROM
    posts
WHERE
    id = $id
    and sqlpage.request_method() = 'GET';

select 
    'form' as component
    , 'Delete Post' as validate
    , 'red' as validate_color
    , 'post' as method
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'hidden' as type
    , 'id' as name
    , $id as value
WHERE
    sqlpage.request_method() = 'GET';

select 
    'Type "delete" to confirm' as label
    , 'confirm' as name
    , true as required
WHERE
    sqlpage.request_method() = 'GET';

select 
    'redirect' as component
    , 'delete_post?id=' || $id || '&invalid=1' as link
WHERE
    sqlpage.request_method() = 'POST'
    and lower($confirm) != 'delete';

DELETE FROM sqlpage_files
WHERE
    post_id = $id
    and sqlpage.request_method() = 'POST'
    and lower($confirm) = 'delete';
    
DELETE FROM posts
WHERE
    id = $id
    and sqlpage.request_method() = 'POST'
    and lower($confirm) = 'delete';

select 
    'redirect' as component
    , 'posts?deleted=1' as link
WHERE
    sqlpage.request_method() = 'POST'
    and lower($confirm) = 'delete';