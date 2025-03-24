insert into settings (
    setting_name
    , setting_value
)
select
    'homepage_header'
    , setting_value
FROM
    settings
WHERE
    setting_name = 'before_post';

insert into settings (
    setting_name
    , setting_value
)
select
    'homepage_footer'
    , setting_value
FROM
    settings
WHERE
    setting_name = 'after_post';