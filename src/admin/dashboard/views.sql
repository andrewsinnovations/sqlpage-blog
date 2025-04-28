SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

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
    status_code = 200
    and created_at >= (now()::date + interval '-30 day')::date
group BY
    created_at::date
order by 
    created_at::date;