SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'chart' as component, 
    'red' as color,
    true as time,
    '404 Errors' as title;

SELECT
    created_at::date as x
    , count(*) as y
FROM
    traffic
WHERE
    status_code = 404
    and created_at >= now()::date + interval '-30 day'
group BY
    created_at::date
order by 
    created_at::date;