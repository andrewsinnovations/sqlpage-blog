SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'chart' AS component,
    'blue' AS color,
    TRUE AS time,
    'Views' AS title
;



SELECT
    created_at::date AS x,
    count(*) AS y
FROM
    traffic
WHERE
    status_code = 200
    AND created_at >= (now()::date + interval '-30 day')::date
GROUP BY
    created_at::date
ORDER BY
    created_at::date
;