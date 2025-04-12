insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
)
SELECT
    'sqlpage/templates/template_' || id || '.handlebars'
    , content
    , current_timestamp
    , current_timestamp
FROM
    template;