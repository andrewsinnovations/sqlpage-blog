SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SET
    user_id = (
        SELECT
            login_id
        FROM
            session
        WHERE
            session_id = sqlpage.cookie ('sid')
            AND sqlpage.request_method () = 'POST'
    )
;



SET
    password_hash = (
        SELECT
            password_hash
        FROM
            login
        WHERE
            id = $user_id::int
            AND sqlpage.request_method () = 'POST'
    )
;



SELECT
    'authentication' AS component,
    'change_password?invalid=1' AS link,
    $current_password AS password,
    $password_hash AS password_hash
WHERE
    sqlpage.request_method () = 'POST'
    AND $password_hash IS NOT NULL
;



SELECT
    'redirect' AS component,
    'change_password?no_match=1' AS link
WHERE
    $password != $confirm_password
    AND sqlpage.request_method () = 'POST'
;



UPDATE login
SET
    password_hash = sqlpage.hash_password ($password)
WHERE
    id = $user_id::int
    AND sqlpage.request_method () = 'POST'
;



SET
    changed = CASE
        WHEN sqlpage.request_method () = 'POST' THEN 1
        ELSE 0
    END
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Change Password')
    ) AS properties
;



SELECT
    'alert' AS component,
    'Password successfully changed.' AS title,
    'green' AS color,
    'check' AS icon
WHERE
    $changed = '1'
;



SELECT
    'alert' AS component,
    'The supplied current password was incorrect, no change was made.' AS title,
    'red' AS color,
    'exclamation-circle' AS icon
    --, true as important
,
    TRUE AS dismissible
WHERE
    $invalid IS NOT NULL
    AND $changed = '0'
;



SELECT
    'alert' AS component,
    'The supplied new password did not match the confirmation, no change was made.' AS title,
    'red' AS color,
    'exclamation-circle' AS icon
    --, true as important
,
    TRUE AS dismissible
WHERE
    $no_match IS NOT NULL
    AND $changed = '0'
;



SELECT
    'form' AS component,
    'post' AS method
WHERE
    sqlpage.request_method () = 'GET'
SELECT
    'current_password' AS name,
    'password' AS type,
    'Current Password' AS label
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'password' AS name,
    'password' AS type,
    'New Password' AS label
WHERE
    sqlpage.request_method () = 'GET'
;



SELECT
    'confirm_password' AS name,
    'password' AS type,
    'Confirm New Password' AS label
WHERE
    sqlpage.request_method () = 'GET'
;
