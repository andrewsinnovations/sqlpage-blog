update settings
SET
    setting_value = 'YYYY-DD-MM HH:MI:SS AM'
WHERE
    setting_name = 'dashboard_date_format';

update settings
SET
    setting_value = 'Day Month FMDD, YYYY'
WHERE
    setting_name = 'post_date_format';