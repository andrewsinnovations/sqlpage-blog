WITH
	settings_data AS (
		SELECT
			json_build_object('setting', setting_name, 'value', setting_value) AS setting
		FROM
			settings
	)
SELECT
	jsonb_object_agg(setting ->> 'setting', setting -> 'value') AS settings
FROM
	settings_data
;
