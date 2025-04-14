SELECT
    'chart' as component, 
    'blue' as color,
    true as time,
    'Views' as title;

SELECT
    created_at::date as x
    , count(*) as y
FROM
    traffic
WHERE
    created_at >= (now()::date + interval '-30 day')::date
group BY
    created_at::date