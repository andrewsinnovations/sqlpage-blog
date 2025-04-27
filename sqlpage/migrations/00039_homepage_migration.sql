-- migrate homepage from being a template to being a page
delete from posts where title = 'Homepage (Site Index)' and post_type = 'page-html';

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
select
    'Homepage (Site Index)'
    , '/'
    , (select content from template where name = 'Homepage')
    , null
    , now()
    , now()
    , 'page-html'
    , (select setting_value from settings where setting_name = 'default_timezone')
    , now();

delete from template where name = 'Homepage';