SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Home')) AS properties;

SELECT
    'card' as component;

SELECT 'views' as embed, 6 as width;
SELECT '404_report' as embed, 6 as width;

SELECT
    'table' as component;

SELECT
    url
    , sum(case when status_code = 200 then 1 else 0 end) as views
    , sum(case when status_code = 404 then 1 else 0 end) as "404 Errors"
FROM
    traffic
group BY
    url
order by 
    count(*) desc
limit 50;