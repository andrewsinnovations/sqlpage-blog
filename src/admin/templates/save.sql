SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

update
    template 
set 
    content = $template
    , name = $name
    , updated_at = current_timestamp
where 
    $id is not null
    and id = $id::int;

insert into template
(
    name
    , content
    , post_default
)
SELECT
    $name
    , $template
    , false
WHERE
    $id is null;

set id = (
    select case when $id is null or $id = '' then currval('template_id_seq') else cast($id as integer) end
) 

insert into template_history (
    template_id
    , created_at
    , content
    , name
)
values (
    $id::int
    , current_timestamp
    , $template
    , $name
);

-- set post default if supplied
update template 
set 
    post_default = case when id = $id::int then true else false end
WHERE
    $default_for_posts is not null;

-- save the template into sqlpage template system
delete from sqlpage_files where path = 'sqlpage/templates/template_' || $id || '.handlebars';
insert into sqlpage_files (
    path
    , contents
    , created_at
    , last_modified
)
values (
    'sqlpage/templates/template_' || $id || '.handlebars'
    , convert_to($template, 'UTF8')
    , current_timestamp
    , current_timestamp    
);

select
    'redirect' as component
    , 'edit?id=' || $id || '&saved=1' as link;
