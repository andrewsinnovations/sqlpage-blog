SELECT
    'dynamic' AS component,
    sqlpage.run_sql ('admin/.check_session.sql') AS properties
;



SELECT
    'dynamic' AS component,
    sqlpage.run_sql (
        'admin/.shell.sql',
        json_object('shell_title', 'Configuration')
    ) AS properties
;



UPDATE settings
SET
    setting_value = $blog_name
WHERE
    setting_name = 'blog_name'
    AND sqlpage.request_method () = 'POST'
;



UPDATE settings
SET
    setting_value = $post_routes
WHERE
    setting_name = 'post_routes'
    AND sqlpage.request_method () = 'POST'
;



UPDATE settings
SET
    setting_value = $dashboard_date_format
WHERE
    setting_name = 'dashboard_date_format'
    AND sqlpage.request_method () = 'POST'
;



UPDATE settings
SET
    setting_value = $post_date_format
WHERE
    setting_name = 'post_date_format'
    AND sqlpage.request_method () = 'POST'
;



UPDATE settings
SET
    setting_value = $default_timezone
WHERE
    setting_name = 'default_timezone'
    AND sqlpage.request_method () = 'POST'
;



SELECT
    'alert' AS component,
    'Blog settings updated.' AS title,
    'blue' AS color,
    'check' AS icon,
    TRUE AS dismissible
WHERE
    sqlpage.request_method () = 'POST'
    AND sqlpage.request_method () = 'POST'
;



SELECT
    'form_with_html' AS component,
    'Save Settings' AS validate,
    'post' AS method
;



SELECT
    'Blog Name' AS label,
    'blog_name' AS name,
    setting_value AS value,
    TRUE AS required
FROM
    settings
WHERE
    setting_name = 'blog_name'
;



SELECT
    'select' AS type,
    'Post Routes' AS label,
    'post_routes' AS name,
    TRUE AS required,
    json(
        '[
        {
            "label":"/YYYY/MM/DD/slug"
            ,"value":"ymd_slug"
            ' || CASE
            WHEN setting_value = 'ymd_slug' THEN ', "selected": true'
            ELSE ''
        END || '
        },
        {
            "label":"/YYYY/MM/slug"
            ,"value":"ym_slug"
            ' || CASE
            WHEN setting_value = 'ym_slug' THEN ', "selected": true'
            ELSE ''
        END || '
        },
        {
            "label":"/YYYY/slug"
            ,"value":"y_slug"
            ' || CASE
            WHEN setting_value = 'y_slug' THEN ', "selected": true'
            ELSE ''
        END || '
        },
        {
            "label":"/YYYYMMDD/slug"
            ,"value":"date_slug"
            ' || CASE
            WHEN setting_value = 'date_slug' THEN ', "selected": true'
            ELSE ''
        END || '
        },
        {
            "label":"/slug"
            ,"value":"slug"
            ' || CASE
            WHEN setting_value = 'slug' THEN ', "selected": true'
            ELSE ''
        END || '
        }
    ]'
    ) AS options
FROM
    settings
WHERE
    setting_name = 'post_routes'
;



SELECT
    'select' AS type,
    'Default Timezone' AS label,
    'default_timezone' AS name,
    TRUE AS required,
    setting_value AS value,
    (
        SELECT
            json_agg(options)
        FROM
            (
                SELECT
                    json_build_object('label', name, 'value', name) AS options
                FROM
                    pg_timezone_names
                ORDER BY
                    name
            ) options
    ) AS options
FROM
    settings
WHERE
    setting_name = 'default_timezone'
;



SELECT
    'Date Format (Dashboard)' AS label,
    'dashboard_date_format' AS name,
    setting_value AS value,
    TRUE AS required
FROM
    settings
WHERE
    setting_name = 'dashboard_date_format'
;



SELECT
    'Date Format (Post and Pages)' AS label,
    'post_date_format' AS name,
    setting_value AS value,
    TRUE AS required
FROM
    settings
WHERE
    setting_name = 'post_date_format'
;



SELECT
    'html' AS type,
    '<div class="ps-4"><p>Use these values for formatting dates:</p><ul>
  <li><code>YYYY</code> - 4-digit year (e.g., <strong>2025</strong>)</li>
  <li><code>YY</code> - 2-digit year (e.g., <strong>25</strong>)</li>
  <li><code>MM</code> - 2-digit month number (01-12) (e.g., <strong>04</strong>)</li>
  <li><code>Mon</code> - Abbreviated month name (e.g., <strong>Apr</strong>)</li>
  <li><code>Month</code> - Full month name (e.g., <strong>April</strong>) - padded with spaces by default</li>
  <li><code>DD</code> - 2-digit day of month (01-31) (e.g., <strong>14</strong>)</li>
  <li><code>D</code> - Day of week as number (1-7; Sunday=1)</li>
  <li><code>FMDD</code> - Day of the month as a number (1-31) without leading zero (e.g., <strong>1</strong>)</li>
  <li><code>DY</code> - Abbreviated weekday name (e.g., <strong>Mon</strong>)</li>
  <li><code>Day</code> - Full weekday name (e.g., <strong>Monday</strong>) - padded with spaces by default</li>
  <li><code>HH</code> - Hour (01-12, 12-hour format)</li>
  <li><code>HH24</code> - Hour (00-23, 24-hour format)</li>
  <li><code>MI</code> - Minutes (00-59)</li>
  <li><code>SS</code> - Seconds (00-59)</li>
  <li><code>AM or PM (either works)</code> - Meridian indicator (e.g., <strong>AM</strong> or <strong>PM</strong>)</li>
  <li><code>FM</code> - Format modifier to remove leading/trailing spaces or zeros (e.g., <code>FMMonth</code> displays <strong>April</strong>, not <strong>" April "</strong>)</li>
</ul></div>
' AS html
;



-- MM/DD/YYYY
-- DD/MM/YYYY
-- YYYY/MM/DD
-- DD.MM.YYYY
-- YYYY-MM-DD
-- DD-MMM-YYYY
-- MMM DD, YYYY
-- DD Month YYYY
-- Month DD, YYYY