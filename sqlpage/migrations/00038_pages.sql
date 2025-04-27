insert into posts
(
    title
    , slug
    , content
    , template_id
    , created_at
    , last_modified
    , post_type
    , timezone
    , published_date
)
VALUES
(
    'Homepage (Site Index)'
    , '/'
    , ''
    , (select id from template where name = 'Homepage')
    , now()
    , now()
    , 'page-html'
    , (select setting_value from settings where setting_name = 'default_timezone')
    , now()
)