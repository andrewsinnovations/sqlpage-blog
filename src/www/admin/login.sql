-- GET Method: Show login form
SELECT
    'redirect' AS component,
    '/admin/install' AS link
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            login
    )
;



SET
    login_id = (
        SELECT
            id
        FROM
            login
        WHERE
            sqlpage.request_method () = 'POST'
            AND username = $login
    )
;



SELECT
    'redirect' AS component,
    '/admin?invalid=1' AS link
WHERE
    sqlpage.request_method () = 'POST'
    AND $login_id IS NULL
;



SET
    password_hash = (
        SELECT
            password_hash
        FROM
            login
        WHERE
            username = $login
            AND sqlpage.request_method () = 'POST'
    )
SELECT
    'authentication' AS component,
    '/admin?invalid=1' AS link,
    $password AS password,
    $password_hash AS password_hash
WHERE
    sqlpage.request_method () = 'POST'
    AND $password_hash IS NOT NULL
;



SET
    session_id = sqlpage.random_string (32)
;



INSERT INTO
    session (session_id, login_id, expires_at)
SELECT
    $session_id,
    $login_id::int,
    now() + interval '+30 days'
WHERE
    sqlpage.request_method () = 'POST'
;



SELECT
    'cookie' AS component,
    'sid' AS name,
    $session_id AS value
WHERE
    sqlpage.request_method () = 'POST'
;



SELECT
    'redirect' AS component,
    '/admin/dashboard' AS link
WHERE
    sqlpage.request_method () = 'POST'
;



SELECT
    'shell' AS component,
    (
        SELECT
            setting_value
        FROM
            settings
        WHERE
            setting_name = 'blog_name'
    ) || ' - Administration' AS title,
    ' ' AS footer
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'alert' AS component,
    'Your blog has been setup! You can now login.' AS title,
    'blue' AS color,
    'exclamation-circle' AS icon
    --, true as important
,
    TRUE AS dismissible
WHERE
    sqlpage.request_method () = 'GET'
    AND $success IS NOT NULL
;



SELECT
    'alert' AS component,
    'Invalid username or password.' AS title,
    'red' AS color,
    'exclamation-circle' AS icon
    --, true as important
,
    TRUE AS dismissible
WHERE
    sqlpage.request_method () = 'GET'
    AND $invalid IS NOT NULL
;



SELECT
    'form' AS component,
    '/admin/login' AS action,
    'post' AS method,
    'Login' AS validate
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'login' AS name,
    'Login' AS label
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'password' AS name,
    'Password' AS label,
    'password' AS type
WHERE
    sqlpage.request_method () = 'GET'
;