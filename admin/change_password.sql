SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

set user_id = (
    SELECT
        login_id
    FROM
        session
    WHERE
        session_id = sqlpage.cookie('sid')
        and sqlpage.request_method() = 'POST'
);

set password_hash = (
    select 
        password_hash
    FROM
        login
    WHERE
        id = $user_id
        and sqlpage.request_method() = 'POST'
);

SELECT
    'authentication' as component
    , 'change_password?invalid=1' as link
    , $current_password as password
    , $password_hash as password_hash
WHERE
    sqlpage.request_method() = 'POST'
    and $password_hash is not null;

SELECT
    'redirect' as component
    , 'change_password?no_match=1' as link
WHERE
    $password != $confirm_password
    and sqlpage.request_method() = 'POST';

update 
    login
SET
    password_hash = sqlpage.hash_password($password)
WHERE
    id = $user_id
    and sqlpage.request_method() = 'POST';

set changed = case when sqlpage.request_method() = 'POST' then 1 else 0 end;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql') AS properties;

select 
    'alert' as component
    , 'Password successfully changed.' as title
    , 'green' as color
    , 'check' as icon
where
    $changed = 1;

SELECT
    'alert' as component
    , 'The supplied current password was incorrect, no change was made.' as title
    , 'red' as color
    , 'exclamation-circle' as icon
    --, true as important
    , true as dismissible
where
    $invalid is not null
    and $changed = 0;

SELECT
    'alert' as component
    , 'The supplied new password did not match the confirmation, no change was made.' as title
    , 'red' as color
    , 'exclamation-circle' as icon
    --, true as important
    , true as dismissible
where
    $no_match is not null
    and $changed = 0;

SELECT
    'form' as component
    , 'post' as method
WHERE
    sqlpage.request_method() = 'GET'

SELECT
    'current_password' as name
    , 'password' as type
    , 'Current Password' as label
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'password' as name
    , 'password' as type
    , 'New Password' as label
WHERE
    sqlpage.request_method() = 'GET';

SELECT
    'confirm_password' as name
    , 'password' as type
    , 'Confirm New Password' as label
WHERE
    sqlpage.request_method() = 'GET';
