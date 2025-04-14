SELECT
    'dynamic' as component,
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.shell.sql', json_object('shell_title', 'Configuration')) AS properties;

UPDATE
    settings
SET
    setting_value = $blog_name
WHERE
    setting_name = 'blog_name'
    and sqlpage.request_method() = 'POST';

UPDATE
    settings
SET
    setting_value = $post_routes
WHERE
    setting_name = 'post_routes'
    and sqlpage.request_method() = 'POST';

UPDATE
    settings
SET
    setting_value = $dashboard_date_format
WHERE
    setting_name = 'dashboard_date_format'
    and sqlpage.request_method() = 'POST';

UPDATE
    settings
SET
    setting_value = $post_date_format
WHERE
    setting_name = 'post_date_format'
    and sqlpage.request_method() = 'POST';

SELECT
    'alert' as component
    , 'Blog settings updated.' as title
    , 'blue' as color
    , 'check' as icon
    , true as dismissible
where
    sqlpage.request_method() = 'POST'
    and sqlpage.request_method() = 'POST';

SELECT
    'form_with_html' as component
    , 'Save Settings' as validate
    , 'post' as method;

SELECT
    'Blog Name' as label
    , 'blog_name' as name
    , setting_value as value
    , true as required
FROM
    settings
WHERE
    setting_name = 'blog_name';

SELECT
    'select' as type
    , 'Post Routes' as label
    , 'post_routes' as name
    , true as required
    , json('[
        {
            "label":"/YYYY/MM/DD/slug"
            ,"value":"ymd_slug"
            '|| case when setting_value = 'ymd_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/YYYY/MM/slug"
            ,"value":"ym_slug"
            '|| case when setting_value = 'ym_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/YYYY/slug"
            ,"value":"y_slug"
            '|| case when setting_value = 'y_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/YYYYMMDD/slug"
            ,"value":"date_slug"
            '|| case when setting_value = 'date_slug' then ', "selected": true' else '' end || '
        },
        {
            "label":"/slug"
            ,"value":"slug"
            '|| case when setting_value = 'slug' then ', "selected": true' else '' end || '
        }
    ]') as options
FROM
    settings
WHERE
    setting_name = 'post_routes';

SELECT
    'Date Format (Dashboard)' as label
    , 'dashboard_date_format' as name
    , setting_value as value    
    , true as required
FROM
    settings
WHERE
    setting_name = 'dashboard_date_format';

SELECT
    'Date Format (Post and Pages)' as label
    , 'post_date_format' as name
    , setting_value as value    
    , true as required
FROM
    settings
WHERE
    setting_name = 'post_date_format';

SELECT
    'html' as type,
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
' as html;

-- MM/DD/YYYY
-- DD/MM/YYYY
-- YYYY/MM/DD
-- DD.MM.YYYY
-- YYYY-MM-DD
-- DD-MMM-YYYY
-- MMM DD, YYYY
-- DD Month YYYY
-- Month DD, YYYY    