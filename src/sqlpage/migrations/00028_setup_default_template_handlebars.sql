insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
)
SELECT
    'sqlpage/templates/template_' || id || '.handlebars'
    , convert_to(content, 'UTF8')
    , current_timestamp
    , current_timestamp
FROM
    template;