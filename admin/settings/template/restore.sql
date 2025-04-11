SELECT
    'dynamic' as component,   
    sqlpage.run_sql('admin/.check_session.sql') AS properties;

set content = (
    select 
        content
    FROM
        template_history
    WHERE
        id = $id
);

update template
set content = $content
where id = (
    select template_id from template_history where id = $id
);

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
    id = $id;

select
    'redirect' as component
    , 'edit?id=' || template_id || '&saved=1' as link
FROM
    template_history
WHERE
    id = $id;
