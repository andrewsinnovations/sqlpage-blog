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
    and $id != ''
    and id = $id;

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
    select case when $id is null or $id = '' then last_insert_rowid() else cast($id as integer) end
) 

insert into template_history (
    template_id
    , created_at
    , content
    , name
)
values (
    $id
    , current_timestamp
    , $template
    , $name
);

-- set post default if supplied
update template 
set 
    post_default = case when id = $id then true else false end
WHERE
    $default_for_posts is not null;

select
    'redirect' as component
    , 'edit?id=' || $id || '&saved=1' as link;
