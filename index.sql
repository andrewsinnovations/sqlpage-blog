-- GET Method: Show login form
SELECT
    'redirect' as component
    , '/admin/install' as link
WHERE
    not exists (select * from login);

select 'shell-empty' as component;

set blog_name = (select setting_value from settings where setting_name = 'blog_name');

select 'html' as component
    , replace(setting_value, '{{blog_name}}', $blog_name) as html
FROM
    settings
WHERE
    setting_name = 'homepage_header';

SELECT
    'html' as component
    , '<ol>' as html;

SELECT
    'html' as component,
    '<li><a href="/' || replace(sqlpage_files.path, '.sql', '') || '">' || title || '</a><br/>' || 
      CASE strftime('%m', sqlpage_files.last_modified)
    WHEN '01' THEN 'January'
    WHEN '02' THEN 'February'
    WHEN '03' THEN 'March'
    WHEN '04' THEN 'April'
    WHEN '05' THEN 'May'
    WHEN '06' THEN 'June'
    WHEN '07' THEN 'July'
    WHEN '08' THEN 'August'
    WHEN '09' THEN 'September'
    WHEN '10' THEN 'October'
    WHEN '11' THEN 'November'
    WHEN '12' THEN 'December'
  END || ' ' || strftime('%d, %Y', sqlpage_files.last_modified)
     || '</li>' as html
FROM
    sqlpage_files
    inner join posts
        on sqlpage_files.post_id = posts.id
WHERE
    posts.published = true
order BY
    sqlpage_files.last_modified desc;

SELECT
    'html'
    , '<p>No posts yet.</p>' as html
WHERE
    not exists (SELECT * FROM posts where published = true);

SELECT
    'html' as component
    , '</ol>' as html;

select 'html' as component
    , setting_value as html
FROM
    settings
WHERE
    setting_name = 'homepage_footer';
