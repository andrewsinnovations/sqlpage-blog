set session_data = (
    select
        json_build_object(
            'session_id', session_id
            , 'login_id', login_id
        ) as session_data
    from
        session
    where
        session_id = sqlpage.cookie('sid')
        and expires_at > current_timestamp
);

SELECT
    'redirect' as component
    , '/admin/end_session' as link
WHERE
    $session_data is null;