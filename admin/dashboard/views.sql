SELECT
    'chart' as component, 
    'blue' as color,
    true as time,
    'Views' as title;

SELECT
    date(created_at) as x
    , count(*) as y
FROM
    traffic
WHERE
    date(created_at) >= date(date('now'), '-30 day')
group BY
    date(created_at);