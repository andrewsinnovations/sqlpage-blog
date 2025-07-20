SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Home')
    ) AS properties
;



SELECT
    'card' AS component
;



SELECT
    'views' AS embed,
    6 AS width
;



SELECT
    '404_report' AS embed,
    6 AS width
;



SELECT
    'table' AS component
;



SELECT
    url,
    sum(
        CASE
            WHEN status_code = 200 THEN 1
            ELSE 0
        END
    ) AS views,
    sum(
        CASE
            WHEN status_code = 404 THEN 1
            ELSE 0
        END
    ) AS "404 Errors"
FROM
    traffic
GROUP BY
    url
ORDER BY
    count(*) DESC
LIMIT
    50
;