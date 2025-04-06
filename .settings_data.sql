with settings_data as (
    SELECT
        json_group_array(setting) as data
    FROM
    (
        SELECT
            json_object(
                'setting', setting_name,
                'value', setting_value
            ) as setting
        FROM
            settings
    )
)
select 
    json_group_object(
    json_extract(json_each.value, '$.setting')
    , json_extract(json_each.value, '$.value')
    ) as settings
From
    settings_data,
    json_each(settings_data.data);