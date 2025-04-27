-- GET Method: Show login form
SELECT
    'redirect' as component
    , '/admin/install' as link
WHERE
    not exists (select * from login);

set login_id = (
    SELECT
        id
    FROM
        login
    WHERE
        sqlpage.request_method() = 'POST'
        and username = $login
);

SELECT
    'redirect' as component
    , '/admin?invalid=1' as link
WHERE
    sqlpage.request_method() = 'POST'
    and $login_id is null;

set password_hash = (
    select 
        password_hash
    FROM
        login
    WHERE
        username = $login
        and sqlpage.request_method() = 'POST'
)

SELECT
    'authentication' as component
    , '/admin?invalid=1' as link
    , $password as password
    , $password_hash as password_hash
WHERE
    sqlpage.request_method() = 'POST'
    and $password_hash is not null;

set session_id = sqlpage.random_string(32);

insert into session (
    session_id
    , login_id
    , expires_at
)
select
    $session_id
    , $login_id::int
    , now() + interval '+30 days'
WHERE
    sqlpage.request_method() = 'POST';

SELECT
    'cookie' as component
    , 'sid' as name
    , $session_id as value
WHERE
    sqlpage.request_method() = 'POST';

SELECT
    'redirect' as component
    , '/admin/dashboard' as link
WHERE
    sqlpage.request_method() = 'POST';

select 
    'shell' as component
    , (select setting_value from settings where setting_name = 'blog_name') || ' - Administration' as title
    , ' ' as footer
where
    sqlpage.request_method() = 'GET';

SELECT
    'alert' as component
    , 'Your blog has been setup! You can now login.' as title
    , 'blue' as color
    , 'exclamation-circle' as icon
    --, true as important
    , true as dismissible
where
    sqlpage.request_method() = 'GET'
    and $success is not null;

SELECT
    'alert' as component
    , 'Invalid username or password.' as title
    , 'red' as color
    , 'exclamation-circle' as icon
    --, true as important
    , true as dismissible
where
    sqlpage.request_method() = 'GET'
    and $invalid is not null;

select 
    'form' as component
    , '/admin/login' as action
    , 'post' as method
    , 'Login' as validate
where
    sqlpage.request_method() = 'GET';

select 
    'login' as name
    , 'Login' as label
where
    sqlpage.request_method() = 'GET';

select 
    'password' as name
    , 'Password' as label
    , 'password' as type
where
    sqlpage.request_method() = 'GET';