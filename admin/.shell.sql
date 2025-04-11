set shell = (
    SELECT
        json_set(JSON(sqlpage.read_file_as_text('admin/.shell.json')), '$.title', setting_value) as shell
    FROM
        settings
    WHERE
        setting_name = 'blog_name'
);

set shell = (
    select 
        json_set(JSON($shell), '$.javascript', json_group_array(value)) as shell
    from
    (
        select 
            VALUE
        FROM
            json_each(JSON($shell) -> 'javascript')
        
        union ALL

        SELECT
            VALUE
        from
            json_each(JSON($additional_javascript))
    ) 
)

set shell = (
    select 
        json_set(JSON($shell), '$.javascript_module', json_group_array(value)) as shell
    from
    (
        select 
            VALUE
        FROM
            json_each(JSON($shell) -> 'javascript_module')
        
        union ALL

        SELECT
            VALUE
        from
            json_each(JSON($additional_javascript_module))
    ) 
)

set shell = (
    select 
        json_set(JSON($shell), '$.css', json_group_array(value)) as shell
    from
    (
        select 
            VALUE
        FROM
            json_each(JSON($shell) -> 'css')
        
        union ALL

        SELECT
            VALUE
        from
            json_each(JSON($additional_css))
    ) 
)

SELECT
    'dynamic' as component
    , $shell as properties;
