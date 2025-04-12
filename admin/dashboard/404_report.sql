SELECT
    'chart' as component, 
    'red' as color,
    true as time,
    '404 Errors' as title;

SELECT
    date(created_at) as x
    , count(*) as y
FROM
    traffic
WHERE
    status_code = 404
    and date(created_at) >= date(date('now'), '-30 day')
group BY
    date(created_at);