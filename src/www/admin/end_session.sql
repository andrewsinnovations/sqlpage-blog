DELETE FROM session
WHERE
    session_id = sqlpage.cookie ('sid')
;



SELECT
    'cookie' AS component,
    'sid' AS name,
    TRUE AS remove
;



SELECT
    'redirect' AS component,
    '/admin/index' AS link
;
