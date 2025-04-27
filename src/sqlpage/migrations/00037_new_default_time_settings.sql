update settings
SET
    setting_value = 'YYYY-MM-DD HH:MI:SS AM'
WHERE
    setting_name = 'dashboard_date_format';

update settings
SET
    setting_value = 'Day Month FMDD, YYYY'
WHERE
    setting_name = 'post_date_format';


alter table posts alter column created_at type timestamptz using created_at at time zone 'UTC';
alter table posts alter column last_modified type timestamptz using created_at at time zone 'UTC';