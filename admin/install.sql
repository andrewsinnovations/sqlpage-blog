select 
    'redirect' as component
    , '/admin/install?invalid=1' as link
WHERE
    sqlpage.request_method() = 'POST'
    and (:password != :password_confirm OR :password = '' OR :login = '' OR :blog_name = '');

insert into login (
    username,
    password_hash
)
select
    :login
    , sqlpage.hash_password(:password)
WHERE
    sqlpage.request_method() = 'POST';

insert into settings (
    setting_name
    , setting_value
)
select
    'blog_name'
    , :blog_name
WHERE
    sqlpage.request_method() = 'POST';

-- Setup default routing

insert into settings (
    setting_name
    , setting_value
)
select
    'post_routes'
    , 'y_slug'
WHERE
    sqlpage.request_method() = 'POST';

insert into settings (
    setting_name
    , setting_value
)
select
    'before_post'
    , '<!doctype html>
<html>
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">  
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" integrity="sha384-dpuaG1suU0eT09tx5plTaGMLBsfDLzUCCUXOY2j/LSvXYuG6Bqs43ALlhIqAJVRb" crossorigin="anonymous">

    <title>' || :blog_name || '</title>
  </head>
  <body>
<div class="container-fluid">
<nav class="navbar bg-body-tertiary">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">' || :blog_name || '</a>
  </div>
</nav>
</div>
<div class="container">
'
WHERE
    sqlpage.request_method() = 'POST';

insert into settings (
    setting_name
    , setting_value
)
select
    'after_post'
    , '</div></body>
</html>'
WHERE
    sqlpage.request_method() = 'POST';

select 
    'redirect' as component
    , '/admin?success=1' as link
WHERE
    sqlpage.request_method() = 'POST';

SELECT
    'redirect' as component
    , '/admin' as link
WHERE
    exists (select * from login)
    and sqlpage.request_method() = 'GET';

select 
    'shell' as component
    , 'New Blog Setup' as title
    , '/admin/install' as link
    , ' ' as footer
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'alert' as component
    , 'Invalid password, or the passwords supplied do not match.' as title
    , 'red' as color
    , 'exclamation-circle' as icon
    --, true as important
    , true as dismissible
where
    sqlpage.request_method() = 'GET'
    and $invalid is not null;

SELECT 
    'text' as component
    , 'Welcome to your new blog! Before you can start posting, you need to set up your database.' as contents
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'form' as component
    , '/admin/install' as action
    , 'post' as method
    , 'Save Configuration' as validate
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'blog_name' as name
    , 'Blog Name' as label
    , true as required
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'login' as name
    , 'Login' as label
    , true as required
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'password' as name
    , 'Password' as label
    , 'password' as type
    , true as required
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'password_confirm' as name
    , 'Confirm Your Password' as label
    , 'password' as type
    , true as required
WHERE
    sqlpage.request_method() = 'GET';