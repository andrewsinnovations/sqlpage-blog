set shell = sqlpage.read_file_as_text('admin/.shell.json');

set additional_javascript = (
    select case when $additional_javascript is null or $additional_javascript = '' then '[]' else $additional_javascript end
)

set additional_javascript_module = (
    select case when $additional_javascript_module is null or $additional_javascript_module = '' then '[]' else $additional_javascript_module end
)

set additional_css = (
    select case when $additional_css is null or $additional_css = '' then '[]' else $additional_css end
)

set shell = (
    SELECT
        jsonb_set(sqlpage.read_file_as_text('admin/.shell.json')::jsonb, '{title}', ('"' || setting_value || 
            case when 'Title' is not null then ' - ' || 'Title' else '' end
        || '"')::jsonb)  as shell
    FROM
        settings
    WHERE
        setting_name = 'blog_name'
)

set shell = (
    select 
        jsonb_set($shell::jsonb, '{javascript}', coalesce(json_arrayagg(value), '[]'::jsonb), true) as shell
    from
    (
        select 
	        jsonb_array_elements($shell::jsonb -> 'javascript') as value
        
        union ALL

        SELECT
	        jsonb_array_elements($additional_javascript::jsonb) as value
    ) as value 
) 

set shell = (
    select 
        jsonb_set($shell::jsonb, '{javascript_module}', coalesce(json_arrayagg(value), '[]'::jsonb), true) as shell
    from
    (
        select 
	        jsonb_array_elements($shell::jsonb -> 'javascript_module') as value
        
        union ALL

        SELECT
	        jsonb_array_elements($additional_javascript_module::jsonb) as value
    ) as value 
) 

set shell = (
    select 
        jsonb_set($shell::jsonb, '{css}', coalesce(json_arrayagg(value), '[]'::jsonb), true) as shell
    from
    (
        select 
	        jsonb_array_elements($shell::jsonb -> 'css') as value
        
        union ALL

        SELECT
	        jsonb_array_elements($additional_css::jsonb) as value
    ) as value 
) 

SELECT
    'dynamic' as component
    , $shell as properties;
