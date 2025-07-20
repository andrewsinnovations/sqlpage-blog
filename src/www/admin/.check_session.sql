SET
    session_data = (
        SELECT
            json_build_object('session_id', session_id, 'login_id', login_id) AS session_data
        FROM
            session
        WHERE
            session_id = sqlpage.cookie ('sid')
            AND expires_at > current_timestamp
    )
;



SELECT
    'redirect' AS component,
    '/admin/end_session' AS link
WHERE
    $session_data IS NULL
;