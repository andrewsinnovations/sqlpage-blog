SET
    shell = sqlpage.read_file_as_text ('admin/.shell.json')
;



SET
    additional_javascript = (
        SELECT
            CASE
                WHEN $additional_javascript IS NULL
                OR $additional_javascript = '' THEN '[]'
                ELSE $additional_javascript
            END
    )
SET
    additional_javascript_module = (
        SELECT
            CASE
                WHEN $additional_javascript_module IS NULL
                OR $additional_javascript_module = '' THEN '[]'
                ELSE $additional_javascript_module
            END
    )
SET
    additional_css = (
        SELECT
            CASE
                WHEN $additional_css IS NULL
                OR $additional_css = '' THEN '[]'
                ELSE $additional_css
            END
    )
SET
    shell = (
        SELECT
            jsonb_set(
                sqlpage.read_file_as_text ('admin/.shell.json')::jsonb,
                '{title}',
                (
                    '"' || setting_value || CASE
                        WHEN setting_value IS NOT NULL THEN ' - ' || setting_value
                        ELSE ''
                    END || '"'
                )::jsonb
            ) AS shell
        FROM
            settings
        WHERE
            setting_name = 'blog_name'
    )
SET
    shell = (
        SELECT
            jsonb_set(
                $shell::jsonb,
                '{javascript}',
                coalesce(json_arrayagg (value), '[]'::jsonb),
                TRUE
            ) AS shell
        FROM
            (
                SELECT
                    jsonb_array_elements($shell::jsonb -> 'javascript') AS value
                UNION ALL
                SELECT
                    jsonb_array_elements($additional_javascript::jsonb) AS value
            ) AS value
    )
SET
    shell = (
        SELECT
            jsonb_set(
                $shell::jsonb,
                '{javascript_module}',
                coalesce(json_arrayagg (value), '[]'::jsonb),
                TRUE
            ) AS shell
        FROM
            (
                SELECT
                    jsonb_array_elements($shell::jsonb -> 'javascript_module') AS value
                UNION ALL
                SELECT
                    jsonb_array_elements($additional_javascript_module::jsonb) AS value
            ) AS value
    )
SET
    shell = (
        SELECT
            jsonb_set(
                $shell::jsonb,
                '{css}',
                coalesce(json_arrayagg (value), '[]'::jsonb),
                TRUE
            ) AS shell
        FROM
            (
                SELECT
                    jsonb_array_elements($shell::jsonb -> 'css') AS value
                UNION ALL
                SELECT
                    jsonb_array_elements($additional_css::jsonb) AS value
            ) AS value
    )
SELECT
    'dynamic' AS component,
    $shell AS properties
;
