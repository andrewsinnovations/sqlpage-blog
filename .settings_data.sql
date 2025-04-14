with settings_data as (
	SELECT
		json_build_object(
			'setting', setting_name,
			'value', setting_value
		) as setting
	FROM
		settings
)
SELECT jsonb_object_agg(setting->>'setting', setting->'value') AS settings
FROM settings_data;
