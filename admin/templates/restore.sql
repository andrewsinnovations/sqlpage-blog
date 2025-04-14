SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

set content = (
    select 
        content
    FROM
        template_history
    WHERE
        id = $id::int
);

set template_id = (
    select template_id from template_history where id = $id::int
);

update template
set content = $content
where id = $template_id::int;

insert into template_history (
    template_id
    , content
    , name
    , created_at
)
select 
    template_id
    , content
    , name
    , current_timestamp
FROM
    template_history
WHERE
    id = $id::int;

-- save the template into sqlpage template system
delete from sqlpage_files where path = 'sqlpage/templates/template_' || $template_id || '.handlebars';
insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
)
select
    'sqlpage/templates/template_' || $template_id || '.handlebars'
    , convert_to($content, 'UTF8')
    , current_timestamp
    , current_timestamp    
FROM
    template_history
WHERE
    id = $id::int;

select
    'redirect' as component
    , 'edit?id=' || template_id || '&saved=1' as link
FROM
    template_history
WHERE
    id = $id::int;
