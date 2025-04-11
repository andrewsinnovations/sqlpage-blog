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
    id = $id;

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